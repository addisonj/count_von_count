require 'simplecov'

SimpleCov.start

def fixture_path
  Pathname.new(__FILE__).dirname.join("./fixture").realpath
end

require 'rubygems'
require 'rspec'
require 'count_von_count'

class MockFormatter < CountVonCount::Formatters::Base
  def initialize
  end
  def write_output(obj)
  end
end
