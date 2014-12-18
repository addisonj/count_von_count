require "yaml"
require "json"
require "terminal-table"
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

      private
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
        output = build_table("Code", countObj[:code]).to_s
        output += "\n\n"
        output += build_table("Tests", countObj[:tests]).to_s
        output
      end
      def build_table(name, countObj)
        head = [""] + countObj[:total].keys.map(&:to_s)
        rows = []
        rows << ["total"] + countObj[:total].values
        rows << :separator
        rows << [{value: "By Dir", colspan: 7, align: :center}]
        rows << :separator
        rows.push *countObj[:by_dir].map{ |d, v| [d] + v.values }
        rows << :separator
        rows << [{value: "By File", colspan: 7, align: :center}]
        rows << :separator
        rows.push *countObj[:by_file].map{ |f, v| [f] + v.values }
        Terminal::Table.new title: name, headings: head, rows: rows
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
