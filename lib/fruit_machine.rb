module FruitMachine
  class ModuleNotDefinedError < Exception
  end

  class FruitMachine
    attr_accessor :config

    def initialize(model)
      reset
      @_model = model
      @config = {
        :template_iterator => "children",
        :template_instance => "child"
      }
    end

    def define(klasses, name = nil)
      if klasses.is_a?(Array)
        return klasses.each { |klass| _define klass }
      end
      if !klasses.is_a?(Hash)
        klass = klasses
        klasses = {}
        klasses[name] = klass
      end
      klasses.each_pair { |name, klass|
        _define klass, name
      }
    end

    def create(name, options = {})
      if name.is_a?(Hash)
        options = name
        name = options['module']
        return create(name, options)
      else
        options['module'] = name
      end

      if @_modules[name]
        klass = @_modules[name]
      else
        @_patterns.each_pair { |pattern, class_name|
          if pattern.match name
            klass = class_name
            break
          end
        }
      end

      raise ModuleNotDefinedError if klass == nil
      klass.new(self, options)
    end

    def model(data)
      return data if data.is_a? @_model
      @_model.new data
    end

    def reset
      @_modules = {}
      @_patterns = {}
    end

    private

    def _define(klass, name = nil)

      # Fallback to default name if name is nil
      name = klass.name if name == nil

      # Test name as a potential regex - supress errors in case it fails
      if name.is_a? Regexp
        @_patterns[name] = klass
      else
        @_modules[name] = klass
      end
    end
  end
end
