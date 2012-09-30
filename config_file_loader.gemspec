# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'config_file_loader/version'

Gem::Specification.new do |s|
  s.name          = "config-file-loader"
  s.version       = ConfigFileLoader::VERSION
  s.authors       = ["kbrock"]
  s.email         = "keenan@thebrocks.net"
  s.description   = "simple way to load erb yaml config files. based upon http://railscasts.com/episodes/85-yaml-configuration-file"
  s.summary       = "Load config files from disk"
  s.homepage      = "http://github.com/kbrock/config-file-loader"

  s.files         = `git ls-files`.split($/)
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")  
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec", ">= 1.2.9"
end
