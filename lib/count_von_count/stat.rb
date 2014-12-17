module CountVonCount
  class Stat
     PATTERNS = {
      rb: {
        line_comment: /^\s*#/,
        begin_block_comment: /^=begin/,
        end_block_comment: /^=end/,
        class: /^\s*class\s+[_A-Z]/,
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

    def self.sum(stats)
      stats.reduce(Stat.new) do |prev, val|
        prev + val
      end
    end

    attr_accessor :all, :loc, :methods, :modules, :classes, :comments
    def initialize(all = 0, loc = 0, methods = 0, modules = 0, classes = 0, comments = 0)
      @all = all
      @loc = loc
      @methods = methods
      @modules = modules
      @classes = classes
      @comments = comments
    end

    def + (other)
      self.class.new(all + other.all, loc + other.loc, methods + other.methods, modules + other.modules, classes + other.classes, comments + other.comments)
    end

    def process(file)
      File.open(file) do |io|
        ft = file_type(file)
        patterns = PATTERNS[ft] || {}

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
