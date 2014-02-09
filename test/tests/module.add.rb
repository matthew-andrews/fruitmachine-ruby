require 'minitest/autorun'
require 'fruit_machine_singleton'

module FruitMachine
  class TestModule < MiniTest::Unit::TestCase
    def setup
      @_fm = FruitMachineSingleton.instance
      @_fm.define Test::Apple
      @_fm.define Test::Layout
      @_fm.define Test::Orange
    end

    def teardown
      @_fm.reset
    end

    def test_should_accept_module_instance
    end

    def test_should_store_a_reference_to_the_child_via_slot_if_the_view_added_has_a_slot
    end

    def test_should_accept_json
    end

    def test_the_second_param_should_define_the_slot
    end

    def test_should_be_able_to_define_the_slot_in_the_options_object
    end

    def test_should_remove_a_module_if_it_already_occupies_this_slot
      apple = @_fm.create "apple"
      orange = @_fm.create "orange"
      layout = @_fm.create "layout"
      layout.add apple, 1

      assert_equal layout.slots[1], apple

      layout.add orange, 1

      assert_equal layout.slots[1], orange

      refute layout.module "apple"
    end

    def test_should_remove_the_module_if_it_already_has_parent_before_being_added
      apple = @_fm.create "apple"
      layout = @_fm.create "layout"
      layout.add apple, 1

      assert_equal layout.slots[1], apple

      layout.add apple, 2

      refute layout.slots[1]
      assert_equal apple, layout.slots[2]
    end

    def test_should_do_nothing_if_passed_nothing
      apple = @_fm.create "apple"
      actual = apple.add
      assert_same apple, actual
    end
  end
end
