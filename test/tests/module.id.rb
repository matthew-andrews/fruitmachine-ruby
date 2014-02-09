require 'minitest/autorun'
require 'fruit_machine_singleton'

module FruitMachine
  class TestModuleId < MiniTest::Unit::TestCase
    def setup
      @_fm = FruitMachineSingleton.instance
      @_fm.define Test::Apple
      @_fm.define Test::Layout
    end

    def teardown
      @_fm.reset
    end

    def test_should_return_a_child_by_id
      layout = @_fm.create "layout", {
        "children" => {
          "1" => {
            "module" => "layout",
            "id" => "some_id"
          }
        }
      }
      child = layout.id "some_id"
      assert_instance_of Test::Layout, child
    end

    def test_should_return_the_views_own_id_if_no_arguments_given_
      id = "a_view_id"
      view = @_fm.create "apple", { "id" => id }
      assert_equal id, view.id
    end

    def test_should_not_return_the_views_own_id_the_first_argument_is_undefined
      id = "a_view_id"
      view = @_fm.create "apple", { "id" => id }
      assert_nil view.id nil
    end

    def test_can_find_nested_children
      layout = @_fm.create "layout", {
        "children" => {
          1 => {
            "module" => "layout",
            "id" => "some_id",
            "children" => [{
              "module" => "apple",
              "id" => "deeply_nested"
            }]
          }
        }
      }
      child = layout.id "deeply_nested"
      assert_instance_of Test::Apple, child
    end
  end
end
