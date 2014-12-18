#Count Von Count

![The Count](http://img2.wikia.nocookie.net/__cb20060205225316/muppet/images/3/3c/CT-p0001-ST.jpg)

1! 2! 3! Ah Ah Ah

Count your lines of code and love it

## What it is
`rake stats` and other similiar line counters are rails specific, this counts lines based on a given glob
and support proper counting for ruby, js, and coffee

It supports mutliple output formats including json and yaml.

### To Install
```
gem install count_von_count
```

Or Gemfile, or whatever

### Docs

```Bash
count_von_count count /path/to/dir
#or
cd /path/to/dir
count_von_count
```

#### Options
By default, when you point to a project, it will count all the code in default set of directories:

- app/\*\*/\*.rb
- lib/\*\*/\*.rb

And tests in:

- spec/\*\*/\*\_spec.rb

If you don't want to include these paths, you can pass `--no_default` and add a list of custom paths
using `-c` for code paths and `-t` for test paths. These paths are given relative to the project
directory.

If you want to output in a different format other than text, pass `-f {yaml,json}` to get what you want.

If you want to write the files out to a directory (instead of stdout), pass `-o` with a path and
it will end up in a file called results.txt (or whatever format you choose)
