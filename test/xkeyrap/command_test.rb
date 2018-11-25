require "test_helper"

class CommandTest < Minitest::Test
  def test_receive
    command = Xkeyrap::Command.new
    # puts "#{%w(released pressed repeated)[state]} #{key}"
    refute command.receive(1, :KEY_LEFTCTRL) # pressed
    refute command.receive(2, :KEY_LEFTCTRL) # repeated
    refute command.receive(2, :KEY_LEFTCTRL) # repeated
    refute command.receive(2, :KEY_LEFTCTRL) # repeated
    assert command.receive(1, :KEY_A)
    assert command.receive(0, :KEY_A)
    assert command.receive(0, :KEY_LEFTCTRL)

    # command.receive(42, 'press')
    # assert_equal [42], command.keys

    #puts Key::NUMBER_KEYS
  end
end
