require 'minitest/autorun'
require 'fruit_machine_singleton'
require 'module'
require 'json'
require 'bootstrap'

module FruitMachine
  class TestFruitMachine < MiniTest::Unit::TestCase
    def setup
      @_fm = FruitMachineSingleton.instance
    end

    def teardown
      @_fm.reset
    end

    def test_define_allows_module_to_be_built_via_create
      @_fm.define Test::Apple
      apple = @_fm.create 'apple'
      assert_instance_of Test::Apple, apple
    end

    def test_define_allows_accepts_array
      @_fm.define [Test::Apple, Test::Orange]
      apple = @_fm.create 'apple'
      orange  = @_fm.create 'orange'
      assert_instance_of Test::Apple, apple
      assert_instance_of Test::Orange, orange
    end

    def test_creating_an_undefined_module_throws_error
      assert_raises ModuleNotDefinedError do
        apple = @_fm.create 'apple'
      end
    end

    def test_defining_an_non_existent_class_throws_error
      assert_raises NameError do
        apple = @_fm.define Test::Silly
      end
    end

    def test_create_should_be_able_to_understand_json_encodable_array
      @_fm.define Test::Apple
      @_fm.define Test::Orange
      @_fm.define Test::Layout

      json = '{
        "module": "layout",
        "children": {
          "1": {
            "module": "apple"
          },
          "2": {
            "module": "orange"
          }
        }
      }'

      layout = @_fm.create(JSON.parse(json))
      assert_equal "layout", layout.class.name
      slot1 = layout.slots["1"];
      slot2 = layout.slots["2"];
      assert_equal "apple", slot1.class.name
      assert_equal "orange", slot2.class.name
    end

    def test_can_build_your_own_fruitmachines
      myfm = Test::MyFruitMachine.new Test::MyModel
      myfm.define Test::Apple
      apple = myfm.create 'apple'
      assert_instance_of Test::Apple, apple
    end

    def test_exception_throw_if_build_your_own_fruitmachine_with_bad_model
      assert_raises NameError do
        Test::MyFruitMachine.new Test::MyBadModel
      end
    end

    def test_model_always_instantiated
      myfm = Test::MyFruitMachine.new Test::MyModel
      myfm.define Test::Apple
      apple = myfm.create 'apple', {
        'model' => { 'collection' => [1, 2, 3] }
      }
      assert_instance_of Test::MyModel, apple.model
    end

    def test_model_already_instantiated
      @_fm.define Test::Apple
      model = MattAndrews::Model.new({ "collection" => [1, 2, 3] })
      apple = @_fm.create "apple", { "model" => model }
      assert_instance_of MattAndrews::Model, apple.model
    end

    def test_should_be_able_two_define_same_module_twice

      # Default
      @_fm.define Test::Apple

      # Simple
      @_fm.define Test::Apple, "crabapple"

      # Array
      @_fm.define({
        "toffee-apple" => Test::Apple,
        "apple-pie" => Test::Apple
      })

      crabapple = @_fm.create "crabapple"
      assert_equal "crabapple", crabapple.name

      toffee_apple = @_fm.create "toffee-apple"
      assert_equal "toffee-apple", toffee_apple.name

      apple_pie = @_fm.create "apple-pie"
      assert_equal "apple-pie", apple_pie.name
    end

    def test_modules_can_be_defined_with_regexes_for_names
      @_fm.define Test::Orange, /[A-Z]+/
      @_fm.define Test::Apple, /.*/
      @_fm.define Test::Orange
      @_fm.define Test::Pear, 'not-a-pear'

      apple = @_fm.create 'apple'
      cabbage = @_fm.create 'cabbage'
      orange = @_fm.create 'orange'
      pear = @_fm.create 'pear'
      notAPear = @_fm.create 'not-a-pear'
      capitals = @_fm.create 'CAPITALS'

      assert_instance_of Test::Apple, apple
      assert_instance_of Test::Apple, cabbage
      assert_instance_of Test::Orange, capitals
      assert_instance_of Test::Apple, pear

      # Prefer explicitly named modules over regex matched modules
      assert_instance_of Test::Orange, orange
      assert_instance_of Test::Pear, notAPear
    end
  end
end
