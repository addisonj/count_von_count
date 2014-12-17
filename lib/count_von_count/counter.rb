module CountVonCount

  class Counter
    attr_accessor :path, :code_paths, :test_paths, :formatter

    def initialize(path, code_paths, test_paths, formatter)
      @path = path
      @formatter = formatter
      @code_paths = expand_directories(code_paths)
      @test_paths = expand_directories(test_paths, "spec")
    end

    def expand_directories(globs, file_pattern = '')
      Dir.chdir(@path) do
        globs.flat_map do |g|
          Pathname.glob(g).select{|f| f.basename.to_s.include?(file_pattern) }.map(&:dirname).uniq.map(&:realpath)
        end
      end
    end


    def run
      results = {
        code: calc_for_directories(code_paths, "*.{rb,coffee,js}"),
        tests: calc_for_directories(test_paths, "*_spec.rb")
      }
      formatter.write_output(results)
    end

    def files_in_dir(dir, glob)
      Dir.chdir(dir) do
        Pathname.glob(glob).reject {|f| f.directory?} .map(&:realpath)
      end
    end

    def calc_for_directories(dirs, glob = "*")
      all_stats = []
      by_dir = {}
      by_file = {}
      dirs.each do |d|
        stats_for_dir = []
        files_in_dir(d, glob).each do |file|
          stat = Stat.new
          stat.process(file)
          unless stat.empty?
            by_file[rel_path(file)] = stat.to_hash
            stats_for_dir.push(stat)
            all_stats.push(stat)
          end
        end
        dir_sum = Stat.sum(stats_for_dir)
        by_dir[rel_path(d)] = dir_sum.to_hash unless dir_sum.empty?
      end
      total = Stat.sum(all_stats).to_hash
      {total: total, by_dir: by_dir, by_file: by_file}
    end

    def rel_path(p)
      Pathname.new(p).relative_path_from(@path).to_s
    end
  end
end
