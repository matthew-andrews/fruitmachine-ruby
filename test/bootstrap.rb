require 'fruit_machine'
require 'module'
require 'model'

module Test
  class Apple < FruitMachine::Module
    def self.name
      'apple'
    end
  end
  class Orange < FruitMachine::Module
    def self.name
      'orange'
    end
  end
  class Pear < FruitMachine::Module
    def self.name
      'pear'
    end
  end
  class Layout < FruitMachine::Module
    def self.name
      'layout'
    end
  end
  class MyModel < MattAndrews::Model
  end
  class MyFruitMachine < FruitMachine::FruitMachine
  end
end
