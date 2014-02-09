require 'minitest/autorun'
require 'fruit_machine_singleton'

module FruitMachine
  class TestModuleToHtml < MiniTest::Unit::TestCase
    def setup
      @_fm = FruitMachineSingleton.instance
      @_fm.define Test::Apple
      @_fm.define Test::Layout
    end

    def teardown
      @_fm.reset
    end

    def test_should_return_a_string
      layout = @_fm.create "layout"
      html = layout.to_html
      assert html.is_a?(String)
    end

    def test_should_print_the_child_html_into_the_corresponding_slot
      apple = @_fm.create "apple", { "slot" => 1 }
      layout = @_fm.create "layout", { "children" => [apple] }

      assert_equal 1, apple.slot
      assert_same apple, layout.module("apple")
      assert_same apple, layout.slots[1]

      apple_html = apple.to_html
      layout_html = layout.to_html

      assert layout_html.include? apple_html
    end

    def test_should_print_the_child_html_by_id_if_no_slot_is_found
      apple = @_fm.create "apple", { "id" => 1 }
      layout = @_fm.create "layout", { "children" => [apple] }

      apple_html = apple.to_html
      layout_html = layout.to_html

      assert layout_html.include? apple_html
    end

    def test_should_fallback_to_printing_children_by_id_if_no_slot_is_present
      layout = @_fm.create "layout", {
        "children" => [{
          "module" => "apple",
          "id" => 1
        }]
      }

      layout_html = layout.to_html
      assert layout_html.include? "apple"
    end
  end
end
