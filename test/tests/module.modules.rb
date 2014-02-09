require 'minitest/autorun'
require 'fruit_machine_singleton'

module FruitMachine
  class TestModuleModule < MiniTest::Unit::TestCase
    def setup
      @_fm = FruitMachineSingleton.instance
      @_fm.define Test::Apple
      @_fm.define Test::Orange
      @_fm.define Test::Pear
      @_fm.define Test::Layout

      layout = @_fm.create "layout"
      apple = @_fm.create "apple", { "slot" => "slot_1" }
      orange = @_fm.create "orange", { "slot" => "slot_2" }
      pear = @_fm.create "pear", { "slot" => "slot_3" }

      layout.add(apple).add(orange).add(pear)
      @_view = layout
    end

    def teardown
      @_fm.reset
    end

    def test_should_return_all_descendant_views_matching_the_given_module_type
      oranges = @_view.modules "orange"
      pears = @_view.modules "pear"

      assert_equal 1, oranges.length
      assert_equal 1, pears.length
    end

    def test_should_return_multiple_views_if_they_exist
      @_view.add({ "module" => "pear" })
      assert_equal 2, @_view.modules("pear").length
    end

  end
end
