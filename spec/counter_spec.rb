require 'spec_helper'

def fp(p)
  Pathname.new(fixture_path).join(p)
end
describe CountVonCount::Counter do
  let(:formatter) do
    MockFormatter.new
  end
  let(:code_glob) do
    ["app/**/*.rb"]
  end
  let(:counter) do
    return CountVonCount::Counter.new(fixture_path, code_glob, [], formatter)
  end

  let(:counter_test) do
    return CountVonCount::Counter.new(fixture_path, code_glob, code_glob, formatter)
  end

  describe "#expand_globs" do
    it "should expand the list of files to include the ones we expect" do
      expect(counter.expand_globs(code_glob)).to eq [fp("app/controllers/test_controller.rb"), fp("app/models/foo.rb"), fp("app/models/test.rb")]
    end
  end

  describe "#run" do
    it "should try to output a hash in the format we expect" do
      allow(formatter).to receive(:write_output) do |output|
        %i(total by_dir by_file).each do |k|
          expect(output[:code]).to have_key(k)
        end
        %w(app/models app/controllers).each do |d|
          expect(output[:code][:by_dir]).to have_key(d)
        end
        %w(app/models/test.rb app/models/test.rb app/controllers/test_controller.rb).each do |d|
          expect(output[:code][:by_file]).to have_key(d)
        end
      end
      counter.run
    end

    it "shouldn't have a test section if no tests" do
      allow(formatter).to receive(:write_output) do |output|
        expect(output[:test]).to be_nil
      end
      counter.run
    end

    it "should have a test section if there are tests" do
      allow(formatter).to receive(:write_output) do |output|
        expect(output[:tests]).to be_truthy
      end
      counter_test.run
    end
  end
end
