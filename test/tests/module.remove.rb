require 'minitest/autorun'
require 'fruit_machine_singleton'

module FruitMachine
  class TestModuleRemove < MiniTest::Unit::TestCase
    def setup
      @_fm = FruitMachineSingleton.instance
      @_fm.define Test::Apple
      @_fm.define Test::Layout
      @_fm.define Test::Orange
    end

    def teardown
      @_fm.reset
    end

    def test_should_remove_the_child_passed_from_the_parents_children_array
      list = @_fm.create "layout"
      apple1 = @_fm.create "apple"
      apple2 = @_fm.create "apple"

      list.add(apple1).add(apple2)

      list.remove apple1

      refute list.children.include? apple1
    end

    def test_should_remove_itself_if_called_with_no_arguments
      list = @_fm.create "layout"
      apple = @_fm.create "apple", { "id" => "foo" }

      list.add apple
      apple.remove

      refute list.children.include? apple
    end

    def test_should_remove_reference_back_to_parent_view
      layout = @_fm.create "layout"
      apple = @_fm.create "apple", { "slot" => 1 }

      layout.add apple
      assert_equal layout, apple.parent

      layout.remove apple
      refute apple.parent
    end

    def test_should_remove_slot_reference
      layout = @_fm.create "layout"
      apple = @_fm.create "apple", { "slot" => 1 }

      layout.add apple
      assert_same apple, layout.slots[1]

      layout.remove apple
      refute layout.slots[1]
    end

    def test_should_not_remove_itself_if_first_argument_is_null
      layout = @_fm.create "layout"
      apple = @_fm.create "apple", { "slot" => 1 }

      layout.add apple
      assert_same apple, layout.module("apple")

      apple.remove nil
      assert_same apple, layout.module("apple")
    end
  end
end
