require 'fruit_machine'
require 'matt_andrews/model'

module FruitMachine
  class FruitMachineSingleton
    private_class_method :new
    @@instance = nil

    def self.instance
      @@instance = FruitMachine.new(MattAndrews::Model) if @@instance == nil
      @@instance
    end

    def self.reset
      @@instance = nil
    end
  end
end
