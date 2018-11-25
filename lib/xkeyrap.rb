require "xkeyrap/version"
require 'xkeyrap/key'
require "xkeyrap/command"

require 'xlib-objects'
require "evdev"
require 'libevdev'
require 'uinput/device'

module Xkeyrap
  class Cli

    def self.run(device)
      display = XlibObj::Display.new(':0')
      device = Uinput::Device.new do
        self.name = "Xkeyrap virtual device"
        self.type = LinuxInput::BUS_VIRTUAL

        Xkeyrap::Key::ALL_KEYS.each do |k|
          self.add_key(k)
        end

        self.add_event(:EV_KEY)
        self.add_event(:EV_SYN)
      end

      keyboard = Evdev.new(device)


      #puts keyboard.supports_event? :KEY_ENTER
      #puts keyboard.supports_event? :KEY_KPENTER
      keyboard.grab

      command = Command.new(device, nil)

      key_handler = keyboard.on(*Xkeyrap::Key::ALL_KEYS) do |state, key|
        root_window = display.screens.first.root_window
        top_level_windows = root_window.property(:_NET_CLIENT_LIST_STACKING)
        focused_window = display.focused_window
        wm_class_name = if focused_window.property("WM_CLASS")
                          focused_window.property("WM_CLASS")[1]
                        else
                          get_parent_window_name(display, top_level_windows, focused_window)
                        end

        command.receive(state, key, wm_class_name)
      end

      loop do
        begin
          keyboard.handle_event
        rescue Evdev::AwaitEvent
          Kernel.select([keyboard.event_channel])
          retry
        end
      end
    end

    def self.get_parent_window_name(display, top_level_windows, focused_window)
      root     = FFI::MemoryPointer.new :Window
      parent   = FFI::MemoryPointer.new :Window
      number   = FFI::MemoryPointer.new :uint
      children = FFI::MemoryPointer.new :pointer
      q = Xlib.XQueryTree(display.to_native, focused_window.to_native, root, parent, children, number)
      parent_window_id = parent.read(:int)
      parent_window = top_level_windows.select {|tlw| tlw.id == parent_window_id }.first
      parent_window.property("WM_CLASS")[1]
    end
  end
end
