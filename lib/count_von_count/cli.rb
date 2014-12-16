require 'thor'
require 'count_von_count'

module CountVonCount

  class CLI < Thor

    desc "count PATH", "count the number of lines of code"
    long_desc <<-DESC
      By default, when you point to a project, it will count all the code in default set of directories:

        - app/**/*.rb
        - lib/**/*.rb

      And tests in:
        - spec/**/*_spec.rb

      If you don't want to include these paths, you can pass --no_default and add custom paths
      using `-c` for code paths and `-t` for test paths. These paths are given relative to the project
      directory.

      If you want to output in a different format other than text, pass `-f {yaml,json}` to get what you want.

      If you want to write the files out to a directory (instead of stdout), pass -o with a path and
      it will end up in a file called results.txt (or whatever format you choose)
    DESC

    option :code, type: :string, aliases: :c, desc: "Add a relative code path to count"
    option :test, type: :string, aliases: :t, desc: "Add a relateive test path to count"
    option :no_default, type: :boolean, aliases: :n, desc: "Don't include default paths", default: false
    option :format, type: :string, aliases: :f, desc: "The format to output to, valid are yaml,json,txt", default: "txt"
    option :outout, type: :string, aliases: :o, desc: "A directory to write the results to"

    def count(path="./")
      CountVonCount.new(path, options[:code], options[:test], options[:no_default], options[:format], options[:output])
    end

    default_task :count
  end

end
