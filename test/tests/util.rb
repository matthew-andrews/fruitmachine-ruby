require 'minitest/autorun'
require 'util'

module FruitMachine
  class TestUtil < MiniTest::Unit::TestCase
    def test_unique_id_returns_string
      first = Util::unique_id
      assert first.is_a?(String)
    end

    def test_unique_id_returns_differently
      first = Util::unique_id
      second = Util::unique_id

      refute_equal first, second
    end
  end
end
