# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mina/nginx/version'

Gem::Specification.new do |spec|
  spec.name          = "mina-nginx"
  spec.version       = Mina::Nginx::VERSION
  spec.authors       = ["hbin"]
  spec.email         = ["huangbin88@foxmail.com"]
  spec.summary       = %q{Mina tasks for handle with Nginx.}
  spec.description   = %q{Configuration and managements Mina tasks for Nginx.}
  spec.homepage      = "https://github.com/hbin/mina-nginx.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mina", "~> 0"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
