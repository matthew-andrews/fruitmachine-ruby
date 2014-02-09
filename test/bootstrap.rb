require 'fruit_machine'
require 'module'
require 'matt_andrews/model'

module Test
  class Apple < FruitMachine::Module
    def initialize(machine, options = {})
      @classes = ["foo", "bar"]
      super machine, options
    end
    def self.name
      "apple"
    end
    def template(data)
      data[0] || ""
    end
  end
  class Orange < FruitMachine::Module
    def self.name
      "orange"
    end
    def template(data)
      "I am Orange"
    end
  end
  class Pear < FruitMachine::Module
    def self.name
      "pear"
    end
    def template(data)
      "I am Pear"
    end
  end
  class Layout < FruitMachine::Module
    def self.name
      "layout"
    end
    def template(data)
      (data[1] || "") + (data[2] || "") + (data[3] || "")
    end
  end
  class MyModel < MattAndrews::Model
  end
  class MyFruitMachine < FruitMachine::FruitMachine
  end
end
