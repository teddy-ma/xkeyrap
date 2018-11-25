
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "xkeyrap/version"

Gem::Specification.new do |spec|
  spec.name          = "xkeyrap"
  spec.version       = Xkeyrap::VERSION
  spec.authors       = ["teddy"]
  spec.email         = ["mlc880926@gmail.com"]

  spec.summary       = %q{a sample keyboard remapping tool for X environment}
  spec.homepage      = "https://github.com/teddy-ma/xkeyrap"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.executables << 'xkeyrap'
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry", "~> 0.12.2"

  spec.add_runtime_dependency "evdev", "~> 1.0"
  spec.add_runtime_dependency "libevdev", "~> 1.0"
  spec.add_runtime_dependency "uinput-device", "~> 0.4"
  spec.add_runtime_dependency "xlib-objects", "~> 0.7"
end
