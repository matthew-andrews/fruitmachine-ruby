require 'minitest/autorun'
require 'fruit_machine_singleton'
require 'bootstrap'

module FruitMachine
  class TestModuleClasses < MiniTest::Unit::TestCase
    def setup
      @_fm = FruitMachineSingleton.instance
      @_fm.define Test::Apple
    end

    def teardown
      @_fm.reset
    end

    def test_should_be_able_to_define_classes_on_the_base_class
      view = @_fm.create "apple"
      assert view.to_html.include? 'class="apple foo bar"'
    end

    def test_should_be_able_to_manipulate_the_classes_array_at_any_time
      view = @_fm.create "apple"
      view.classes = ["a", "b", "c"]
      assert view.to_html.include? 'class="apple a b c"'
    end

    def test_should_be_able_to_define_classes_at_instantiation
      view = @_fm.create "apple", { "classes" => ["fizz", "buzz"] }
      assert view.to_html.include? 'class="apple fizz buzz"'
    end
  end
end
