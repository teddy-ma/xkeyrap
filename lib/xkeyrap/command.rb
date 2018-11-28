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
          puts "set modifier key: #{key}"
          self.modifier_key = key # and do nothing to output
        else # state = 0
          puts "clear modifier key: #{self.modifier_key}"
          self.modifier_key = nil
        end
      else # normal key
        if self.modifier_key
          transport(self.modifier_key, key, state, wm_class_name)
        else
          puts "normal key: #{key}"
          output_event(key, state, wm_class_name)
        end
      end
    end

    def transport(modifier_key, key, state, wm_class_name)
      sub_json = self.config[wm_class_name.to_sym] || self.config[:global]
      mapped_modifier_key = sub_json[modifier_key] || self.config[:global][modifier_key] || modifier_key

      if wm_class_name == "Google-chrome"
        if mapped_modifier_key == :KEY_LEFTMETA
          mapped_key_config = {
            :KEY_A => :KEY_HOME,
            :KEY_E => :KEY_END,
            :KEY_B => :KEY_LEFT,
            :KEY_F => :KEY_RIGHT,
            :KEY_N => :KEY_DOWN,
            :KEY_P => :KEY_UP
          }
          mapped_key = mapped_key_config[key] || mapped_key
          puts "transport mapped key is #{mapped_key}"
          output_event(mapped_key, state, wm_class_name)
          self.modifier_key = nil
        else # normal combine (e.g ctrl+c ctrl+v)
          output_combine(mapped_modifier_key, key, state, wm_class_name)
        end
      else
        output_combine(mapped_modifier_key, key, state, wm_class_name)
      end
    end

    def output_combine(modifier_key, key, state, wm_class_name)      
      puts "output combine: #{modifier_key}, #{key}, #{state}, #{wm_class_name}"
      self.output_event(self.modifier_key, 1, wm_class_name)
      self.output_event(key, state, wm_class_name)
      self.output_event(self.modifier_key, 0, wm_class_name)      
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
