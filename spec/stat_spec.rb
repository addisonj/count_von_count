require 'spec_helper'

Stat = CountVonCount::Stat

def stat_num(n)
  Stat.new(*Array.new(6, n))
end

CONTENTS = <<-CON
module Thing
  class Foo
    # comment
    def stuff
    end
    def other
      4 + 4
    end
=begin
one
two
=end
  end
end

CON

describe Stat do
  let(:stat) do
    return Stat.new
  end

  describe "#initialize" do
    it "should initiliaze to empty values" do
      %i(all loc methods modules classes comments).each do |val|
        expect(stat.send(val)).to eq(0)
      end
    end
  end

  describe "#+" do
    it "should add together two stats to create a new stat" do
      expect(stat_num(1) + stat_num(2)).to eq(stat_num(3))
    end
  end

  describe "::sum" do
    it "should sum an array of stats" do
      stats = (1..4).map{ |n| stat_num(n) }
      sum = (1..4).reduce(:+)
      expect(Stat.sum(stats)).to eq(stat_num(sum))
    end
  end

  describe "#parse_by_io" do
    it "should parse a file and updates its numbers" do
      vals = {
        all: 15,
        loc: 9,
        methods: 2,
        modules: 1,
        classes: 1,
        comments: 5
      }

      stat.process_io(StringIO.new(CONTENTS), Stat.get_pattern(:rb))
      vals.each do |k, v|
        expect(stat.send(k)).to eq(v), "expect #{k} to equal #{v} got #{stat.send(k)}"
      end
    end

  end
end
