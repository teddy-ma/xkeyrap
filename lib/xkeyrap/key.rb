#https://github.com/christopheraue/ruby-linux_input/blob/master/lib/linux_input/generated/input.rb

module Xkeyrap
  class Key
    NUMBER_KEYS = [
      :KEY_0,
      :KEY_1,
      :KEY_2,
      :KEY_3,
      :KEY_4,
      :KEY_5,
      :KEY_6,
      :KEY_7,
      :KEY_8,
      :KEY_9
    ]

    MISC_KEYS = [
      :KEY_LEFTBRACE,
      :KEY_RIGHTBRACE,
      :KEY_ENTER,
      :KEY_KPENTER,
      :KEY_SEMICOLON,
      :KEY_APOSTROPHE,
      :KEY_BACKSPACE,
      :KEY_TAB,
      :KEY_DASHBOARD,
      :KEY_GRAVE,
      :KEY_COMMA,
      :KEY_DOT,
      :KEY_SLASH,
      :KEY_BACKSLASH,
      :KEY_HOME,
      :KEY_UP,
      :KEY_PAGEUP,
      :KEY_LEFT,
      :KEY_RIGHT,
      :KEY_END,
      :KEY_DOWN,
      :KEY_PAGEDOWN,
      :KEY_INSERT,
      :KEY_DELETE,
    ]

    LETTER_KEYS = [
      :KEY_Q,
      :KEY_W,
      :KEY_E,
      :KEY_R,
      :KEY_T,
      :KEY_Y,
      :KEY_U,
      :KEY_I,
      :KEY_O,
      :KEY_P,
      :KEY_A,
      :KEY_S,
      :KEY_D,
      :KEY_F,
      :KEY_G,
      :KEY_H,
      :KEY_J,
      :KEY_K,
      :KEY_L,
      :KEY_Z,
      :KEY_X,
      :KEY_C,
      :KEY_V,
      :KEY_B,
      :KEY_N,
      :KEY_M,
    ]

    MODIFIER_KEYS = [
      :KEY_ESC,
      :KEY_LEFTSHIFT,
      :KEY_RIGHTSHIFT,
      :KEY_RIGHTALT,
      :KEY_LEFTALT,
      :KEY_SPACE,
      :KEY_CAPSLOCK,
      :KEY_LEFTMETA,
      :KEY_RIGHTMETA,
      :KEY_LEFTCTRL,
      :KEY_RIGHTCTRL
    ]

    FUNCTION_KEYS = [
      :KEY_F1,
      :KEY_F2,
      :KEY_F3,
      :KEY_F4,
      :KEY_F5,
      :KEY_F6,
      :KEY_F7,
      :KEY_F8,
      :KEY_F9,
      :KEY_F10,
      :KEY_F11,
      :KEY_F12,
    ]

    ALL_KEYS = NUMBER_KEYS + MISC_KEYS + LETTER_KEYS + MODIFIER_KEYS + FUNCTION_KEYS

  end
end
