require "yaml"
require "json"
module CountVonCount
  module Formatters
    class Base
      attr_reader :path
      attr_reader :output_dir
      def initialize(path, output = nil)
        @path = path
        @output_dir = output
      end

      def write_output(countObj)
        formatted = serialize(countObj)
        if output_dir
          write_file(formatted)
        else
          write_stdout(formatted)
        end
      end

      def write_file(formatted)
        output_file = path.join(output_dir).join("results.#{extension}")
        output_file.open("w") do |f|
          f << formatted
        end
      end

      def write_stdout(formatted)
        puts formatted
      end

      def extension
        raise 'Must extend this method'
      end
      def serialize(countObj)
        raise 'Must extend this method'
      end
    end
    class Text < Base
      def extension
        "txt"
      end
      def serialize(countObj)
        # cheat for now
        countObj.to_yaml
      end
    end
    class Json < Base
      def extension
        "json"
      end
      def serialize(countObj)
        countObj.to_json
      end
    end
    class Yaml < Base
      def extension
        "yaml"
      end
      def serialize(countObj)
        countObj.to_yaml
      end
    end
  end
end
