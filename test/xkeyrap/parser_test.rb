require "test_helper"

class ParserTest < Minitest::Test
  def test_parse_to_keys
    assert_equal ["C", "a"], Xkeyrap::Parser.new("C-a").parse_to_keys
    assert_equal ["M", "e"], Xkeyrap::Parser.new("M-e").parse_to_keys
  end
end
