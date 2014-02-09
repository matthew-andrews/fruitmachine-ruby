require 'minitest/autorun'
require 'fruit_machine_singleton'

module FruitMachine
  class TestModuleAdd < MiniTest::Unit::TestCase
    def setup
      @_fm = FruitMachineSingleton.instance
      @_fm.define Test::Apple
      @_fm.define Test::Orange
      @_fm.define Test::Pear
      @_fm.define Test::Layout
    end

    def teardown
      @_fm.reset
    end

    def test_should_add_any_children_passed_into_the_constructor
      children = [ { "module" => "pear" }, { "module" => "orange" } ]
      view = @_fm.create "apple", { "children" => children }
      assert_equal 2, view.children.length
    end

    def test_should_store_a_reference_to_the_slot_if_passed
      view = @_fm.create "apple", {
        "children" => [
          { "module" => "pear", "slot" => "1" },
          { "module" => "orange", "slot" => "2" }
        ]
      }

      assert_equal "pear", view.slots["1"].module
      assert_equal "orange", view.slots["2"].module
    end

    def test_should_store_a_reference_to_the_slot_if_slot_is_passed_as_key_of_children_object
      view = @_fm.create "apple", { "children" => {
        "1" => { "module" => "pear" },
        "2" => { "module" => "orange" }
      }}

      assert_equal "pear", view.slots["1"].module
      assert_equal "orange", view.slots["2"].module
    end

    def test_should_store_a_reference_to_the_slot_if_the_view_is_instantiated_with_a_slot
      apple = @_fm.create "apple", { "slot" => "1" }
      assert_equal "1", apple.slot
    end

    def test_should_prefer_the_slot_on_the_children_object_in_case_of_conflict
      apple = @_fm.create "apple", { "slot" => "1" }
      layout = @_fm.create "layout", {
        "children" => { "2" => apple }
      }

      assert_equal "2", layout.module("apple").slot
    end

    def test_should_create_a_model
      view = @_fm.create "apple"
      assert_instance_of MattAndrews::Model, view.model
    end

    def test_should_adopt_the_fmid_if_passed
      view = @_fm.create("apple", { "fmid" => "1234" })
      assert view.to_html.include? 'id="1234"'
    end

    def test_each
      fm = @_fm
      apple1 = fm.create "apple"
      apple2 = fm.create "apple"
      orange = fm.create "orange"
      view = fm.create("layout", {
        "children" => {
          "1" => apple1,
          "2" => orange,
          "3" => apple2
        }
      })

      # Find the first apple
      search = view.each { |child|
        child if child.module == "apple"
      }

      assert_same apple1, search
      refute_same apple2, search

      search = view.each { |child|
        child if child.module == "orange"
      }

      assert_same orange, search
    end
  end
end
