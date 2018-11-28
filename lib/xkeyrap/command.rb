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
      if Key.is_modifier_key?(key)
        if state == 1 || state == 2
          self.modifier_key = key # and do nothing to output
        else # state = 0
          self.modifier_key = nil
        end
      else
        if self.modifier_key
          transport(self.modifier_key, key, wm_class_name)
        else
          output_event(key, state, wm_class_name)
        end
      end
    end

    def transport(modifier_key, key, wm_class_name)
      sub_json = self.config[wm_class_name.to_sym] || self.config[:global]
      mapped_modifier_key = sub_json[modifier_key] || self.config[:global][modifier_key] || modifier_key

      if wm_class_name == "Google-chrome"
        if mapped_modifier_key == :KEY_LEFTMETA
          if key == :KEY_A
            output_event(:KEY_HOME, 1, wm_class_name)
            output_event(:KEY_HOME, 0, wm_class_name)
          end
          if key == :KEY_E
            output_event(:KEY_END, 1, wm_class_name)
            output_event(:KEY_END, 0, wm_class_name)
          end
          if key == :KEY_B
            output_event(:KEY_LEFT, 1, wm_class_name)
            output_event(:KEY_LEFT, 0, wm_class_name)
          end
          if key == :KEY_F
            output_event(:KEY_RIGHT, 1, wm_class_name)
            output_event(:KEY_RIGHT, 0, wm_class_name)
          end
          if key == :KEY_N
            output_event(:KEY_DOWN, 1, wm_class_name)
            output_event(:KEY_DOWN, 0, wm_class_name)
          end
          if key == :KEY_P
            output_event(:KEY_UP, 1, wm_class_name)
            output_event(:KEY_UP, 0, wm_class_name)
          end
        end
      else
        output_combine(mapped_modifier_key, key)
      end
    end

    def output_combine(modifier_key, key)
      output_event(self.modifier_key, 1)
      output_event(key, state)
      output_event(self.modifier_key, 0)
      self.modifier_key = nil
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
