module FruitMachine
  class Util
    @@_i = 0

    def self.unique_id(prefix = 'id')
      prefix + (self._increment * (rand() * 100000).round).to_s
    end

    private

    def self._increment
      @@_i = @@_i + 1
    end
  end
end
