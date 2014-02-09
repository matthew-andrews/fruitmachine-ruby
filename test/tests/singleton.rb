require 'minitest/autorun'
require 'fruit_machine_singleton'

module FruitMachine
  class TestFruitMachineSingleton < MiniTest::Unit::TestCase
    def test_singleton_is_instance_of_fruit_machine
      singleton = FruitMachineSingleton.instance
      assert_instance_of FruitMachine, singleton
      singleton_again = FruitMachineSingleton.instance
      assert_same singleton, singleton_again
    end

    def teardown
      @_fm = FruitMachineSingleton.reset
    end
  end
end
