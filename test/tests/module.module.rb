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
      apple = @_fm.create "apple", { "slot" => "1" }
      orange = @_fm.create "orange", { "slot" => "2" }
      pear = @_fm.create "pear", { "slot" => "3" }

      layout.add(apple).add(orange).add(pear)
      @_view = layout
    end

    def teardown
      @_fm.reset
    end

    def test_should_return_module_type_if_no_arguments_given
      assert_equal "layout", @_view.module
    end

    def test_should_return_the_first_child_module_with_the_specified_type
      child = @_view.module "pear"
      assert_same @_view.children[2], child
    end

    def test_if_there_is_more_than_one_child_of_this_module_type_only_the_first_is_returned
      @_view.add({ "module" => "apple" })

      child = @_view.module "apple"
      first_child = @_view.children[0]
      last_child = @_view.children[@_view.children.length - 1]

      assert_same child, first_child
      refute_same child, last_child
    end

    def test_can_find_nested_children
      layout = @_fm.create "layout", {
        "children" => {
          "1" => {
            "module" => "orange",
            "id" => "some_id",
            "children" => [
              {
                "module" => "apple",
                "id" => "deeply_nested"
              }
            ]
          }
        }
      }
      child = layout.module "apple"
      assert_equal "deeply_nested", child.id
    end
  end
end
