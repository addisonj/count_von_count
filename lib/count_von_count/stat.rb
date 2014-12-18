module CountVonCount
  class Stat
     PATTERNS = {
      rb: {
        line_comment: /^\s*#/,
        begin_block_comment: /^=begin/,
        end_block_comment: /^=end/,
        class:  /^\s*class\s+[_A-Z]/,
        module: /^\s*module\s+[_A-Z]/,
        method: /^\s*def\s+[_a-z]/,
      },
      js: {
        line_comment: %r{^\s*//},
        begin_block_comment: %r{^\s*/\*},
        end_block_comment: %r{\*/},
        method: /function(\s+[_a-zA-Z][\da-zA-Z]*)?\s*\(/,
      },
      coffee: {
        line_comment: /^\s*#/,
        begin_block_comment: /^\s*###/,
        end_block_comment: /^\s*###/,
        class: /^\s*class\s+[_A-Z]/,
        method: /[-=]>/,
      }
    }

    def self.get_pattern(type)
      return PATTERNS[type]
    end

    def self.sum(stats)
      stats.reduce(Stat.new) do |prev, val|
        prev + val
      end
    end

    VALS = %i(all loc methods modules classes comments)
    attr_accessor *VALS
    def initialize(all = 0, loc = 0, methods = 0, modules = 0, classes = 0, comments = 0)
      @all = all
      @loc = loc
      @methods = methods
      @modules = modules
      @classes = classes
      @comments = comments
    end

    def + (other)
      r = self.class.new
      VALS.each do |v|
        r.send("#{v.to_s}=", (self.send(v) + other.send(v)))
      end
      r
    end

    def == (other)
      VALS.each do |v|
        return false if self.send(v) != other.send(v)
      end
      true
    end

    def process(file)
      File.open(file) do |io|
        ft = file_type(file)
        patterns = PATTERNS[ft] || {}
        process_io(io, patterns)
      end
    end

    def process_io(io, patterns)
      comment_started = false

      while line = io.gets
        @all += 1

        if comment_started
          @comments += 1
          if patterns[:end_block_comment] && line =~ patterns[:end_block_comment]
            comment_started = false
          end
          next
        else
          if patterns[:begin_block_comment] && line =~ patterns[:begin_block_comment]
            @comments += 1
            comment_started = true
            next
          end
        end

        @classes   += 1 if patterns[:class] && line =~ patterns[:class]
        @methods   += 1 if patterns[:method] && line =~ patterns[:method]
        @modules   += 1 if patterns[:module] && line =~ patterns[:module]
        if (patterns[:line_comment] && line =~ patterns[:line_comment])
          @comments += 1
        elsif line !~ /^\s*$/
          @loc += 1
        end
      end
    end


    def to_h
      {all: all, loc: loc, methods: methods, modules: modules, classes: classes, comments: comments}
    end

    def file_type(file_path)
      File.extname(file_path).sub(/\A\./, '').downcase.to_sym
    end

    def empty?
      loc == 0
    end
  end
end
