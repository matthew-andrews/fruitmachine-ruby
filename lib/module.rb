module FruitMachine
  class Module
    attr_accessor :children, :slot, :slots, :model, :parent

    def initialize(machine, options = {})
      @children = []
      @slots = {}
      @_ids = {}
      @_modules = {}
      @fruitmachine = machine
      _configure options
      _add options["children"] if options["children"]
    end

    def add(child = nil, options = nil)
      return self unless child

      # If it's not a Module, make it one.
      unless child.is_a?(Module)
        child = @fruitmachine.create child["module"], child
      end

      # Options
      at = options.is_a?(Hash) && !options["at"].nil? ? options["at"] : nil
      slot = options.is_a?(Hash) && !options["slot"].nil? ? options["slot"] : (!options.is_a?(Hash) ? options : nil)

      # Remove this view first if it already has a parent
      child.remove if !child.parent.nil?

      # Assign a slot (prefering defined option)
      slot = child.slot = !slot.nil? ? slot : child.slot

      # Remove any module that already occupies this slot
      if slot && !@slots[slot].nil?
        @slots[slot].remove
      end

      if at.nil?
        @children.push child
      else
        @children.insert at, child
      end
      _addLookup(child)

      # Allow chaining
      self
    end

    def each
      @children.each { |child|
        result = yield child
        return result unless result.nil?
      }
    end

    def id(id = nil)
      return @_id if id.nil?
      return @_ids[id] if @_ids[id]
      return each { |view|
        return view.id id
      }
    end

    def module(key = nil)
      return @_module if key.nil?
      return @_modules[key][0] if @_modules[key] && @_modules[key][0]
      each { |view| view.module key }
      nil
    end

    def name
      @_module
    end

    def remove(param1 = {}, param2 = {})
      return self if param1.nil?

      # Allow view.remove(child[, options]) and view.remove([options]);
      return param1.remove param2 if param1.is_a? Module

      # Unless stated otherwise, remove the view element from its
      # parent node.
      if @parent

        # Remove reference from views array
        index = @parent.children.index self
        @parent.children.delete_at index

        # Remove references from the lookup
        @parent.removeLookup self
      end
      self
    end

    def removeLookup(child)
      mod = child.module

      # Remove the module lookup
      index = @_modules[mod].index child
      @_modules[mod].delete_at index

      # Remove the id and slot lookup
      @_ids.delete child.id
      @slots.delete child.slot
      child.parent = nil
    end

    private

    def _add(children)
      if children.is_a?(Array)
        children.each_index { |index| add children[index] }
      else
        children.each_pair { |key, value|
          add value, key
        }
      end
    end

    def _addLookup(child)
      mod = child.module

      # Add a lookup for module
      @_modules[mod] = [] unless @_modules[mod]
      @_modules[mod].push child

      # Add a lookup for id
      @_ids[child.id] = child;

      # Store a reference by slot
      @slots[child.slot] = child if child.slot

      # Add a reference to the child's parent
      child.parent = self
    end

    def _configure(options)

      # TODO: Finish implementing setup properties
      @slot = !options["slot"].nil? ? options["slot"] : nil
      @_module = !options["module"].nil? ? options["module"] : self.class.name

      # Use the model passed in,
      # or create a model from
      # the data passed in.
      model = options["model"] ? options["model"] : (options["data"] ? options["data"] : [])

      # Ensure model is a model
      @model = @fruitmachine.model model
    end
  end
end
