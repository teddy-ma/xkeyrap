require "evdev"
require 'libevdev'
require 'uinput/device'

module Xkeyrap
  class Command
    attr_accessor :modifier_key
    attr_accessor :output_device
    attr_accessor :config

    def initialize(device, config)
      self.modifier_key = nil
      self.output_device = device
      unless config
        self.config = {
          global: {
            KEY_CAPSLOCK: :KEY_LEFTCTRL,
            KEY_LEFTCTRL: :KEY_CAPSLOCK,
            KEY_LEFTALT:  :KEY_LEFTMETA,
            KEY_LEFTMETA: :KEY_LEFTALT
          },
          "Google-chrome": {
            KEY_LEFTALT: :KEY_LEFTCTRL,
            KEY_CAPSLOCK: :KEY_LEFTMETA,
            KEY_LEFTMETA: :KEY_LEFTALT  
          }
        }
      end
    end

    def receive(state, key, wm_class_name = "global")
      if Key.is_modifier_key?(key) && state == 1
        self.modifier_key = key # and do nothing to output
      else
        if self.modifier_key
          output_event(self.modifier_key, 1)
          output_event(key, state)
          output_event(self.modifier_key, 0)
          self.modifier_key = nil
        else
          output_event(key, state, wm_class_name)
        end
      end
    end

    def output_event(key, state, wm_class_name)
      sub_json = self.config[wm_class_name.to_sym] || self.config[:global]
      mapped_key = sub_json[key] || self.config[:global][key] || key
      puts "#{wm_class_name} | #{state} | origin: #{key} | mapped: #{mapped_key}"
      self.output_device.send_event(:EV_KEY, mapped_key, state)
      self.output_device.send_event(:EV_SYN, :SYN_REPORT)
    end

  end
end
