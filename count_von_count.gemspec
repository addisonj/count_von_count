lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'count_von_count/version'

Gem::Specification.new do |s|
  s.name        = "count_von_count"
  s.version     = CountVonCount::VERSION
  s.authors     = ["Addison Higham"]
  s.email       = "ahigham@instructure.com"
  s.homepage    = "http://github.com/addisonj/count_von_count"
  s.summary     = "Count lines of code and report it"
  s.description = "Count lines of code with granularity and output it various formats"
  s.required_rubygems_version = ">= 1.3.6"
  s.files = `git ls-files -z`.split("\x0")
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]


  s.add_dependency 'thor'
  s.add_dependency 'code_metrics'
  s.license = 'MIT'
end
