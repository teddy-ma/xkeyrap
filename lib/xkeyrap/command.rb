require "evdev"
require 'libevdev'
require 'uinput/device'

module Xkeyrap
  class Command
    attr_accessor :keys
    attr_accessor :modifier_keys
    attr_accessor :output_device
    attr_accessor :config

    def initialize(device, config)
      self.keys = Set.new
      self.modifier_keys = Set.new
      self.output_device = device
      unless config
        self.config = {
          global: {
            KEY_CAPSLOCK: :KEY_LEFTCTRL,
            KEY_LEFTCTRL: :KEY_CAPSLOCK,
            KEY_LEFTALT:  :KEY_LEFTMETA,
            KEY_LEFTMETA: :KEY_LEFTALT
          },
          "Firefox": {
            KEY_LEFTALT: :KEY_LEFTCTRL,
            KEY_CAPSLOCK: :KEY_LEFTMETA,
            KEY_LEFTMETA: :KEY_LEFTALT  
          }
        }
      end
    end

    def receive(state, key, wm_class_name = "global")
      sub_json = self.config[wm_class_name.to_sym] || self.config[:global]
      mapped_key = sub_json[key] || self.config[:global][key] || key
      puts "#{wm_class_name} | #{state} | origin: #{key} | mapped: #{mapped_key}"
      self.output_device.send_event(:EV_KEY, mapped_key, state)
      self.output_device.send_event(:EV_SYN, :SYN_REPORT)
    end

  end
end
