module CountVonCount

  class Counter
    attr_accessor :path, :code_paths, :test_paths, :formatter

    def initialize(path, code_paths, test_paths, formatter)
      @path = path
      @formatter = formatter
      @code_paths = expand_globs(code_paths)
      @test_paths = expand_globs(test_paths)
    end

    def expand_globs(globs)
      Dir.chdir(@path) do
        globs.flat_map do |g|
          Pathname.glob(g).reject{|f| f.directory? }.map(&:realpath)
        end
      end
    end


    def run
      results = {
        code: process_files(code_paths),
        tests: process_files(test_paths)
      }
      formatter.write_output(results)
    end

    def process_files(files)
      files_by_dir = files.group_by(&:dirname)
      all_stats = []
      by_dir = {}
      by_file = {}
      files_by_dir.each do |dir, dir_files|
        stats_for_dir = []
        dir_files.each do |file|
          stat = Stat.new
          stat.process(file)
          unless stat.empty?
            by_file[rel_path(file)] = stat.to_h
            stats_for_dir.push(stat)
            all_stats.push(stat)
          end
        end
        dir_sum = Stat.sum(stats_for_dir)
        by_dir[rel_path(dir)] = dir_sum.to_h unless dir_sum.empty?
      end
      total = Stat.sum(all_stats).to_h
      {total: total, by_dir: sort_by_loc(by_dir), by_file: sort_by_loc(by_file)}
    end

    def sort_by_loc(hash)
      hash.sort_by { |_k, stat| stat[:loc] }.reverse.to_h
    end

    def rel_path(p)
      Pathname.new(p).relative_path_from(@path).to_s
    end
  end
end
