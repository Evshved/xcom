# Web Server Log Parser

[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)

This is a project to parse a web server log file and extract number
of visits per page in total and unique methods.

## Run

First clone the repository and `cd` into the root of the project.
Ruby 2.7.1 is used to develop.

To install dependencies execute:

```
$ bundle install
```

And to run the parser:

```
$ ./parser.rb data/webserver.log
```

## Test and Lint

Rspec is utilized to write test and Rubocop to lint the code. To run
tests run:

```
$ rspec
```

and to run rubocop:

```
$ bundle exec rubocop
```

### Test coverage

The code base is 100% under test coverage.

## Architecture

Entry point of the project is `parser.rb` script. It checks if there
is enough passed argument in terminal. Then, it uses `FileReader`
class to create a file handler refer to passed argument. Finally,
an instance of `LogAnalyzer` is created with reader and `Parser` and `analyze`
method is called on it.

In order to fulfill its task, `LogAnalyzer` does the following steps:

* Read log file with received reader and pass lines to `LinesFormatter`
* Send line_formatter with lines inside to different analyzers
* Each analyzer returns array of objects with analyzed data prepared to be printed
* Each array is passed to Printer, where it's finally printed

This architecture is easy to extend because if once it's needed to add another
type of analyzer, it will be needed to just add a new class with new formulas inside.
Introduced models for analysis results (`PageView`, `Transition`) which know
how to be printed, help eliminate dependency between printer and data it prints.
Injection of dependencies to `Printer` and `FileReader` at the upper architecture
level helps to achieve easy extention for other file and output formats.

## To Do

The project has room for improvement:

* Add usage document to `./parser.rb` command.
* Add `--help` command.
* In case it will be needed to process bigger sets of data, parallel processing might be implementd.
* Provide an option for the terminal command to select needed analyzer. In this case we can move Analyzers injections to upper architecture level.
* Encapsulate solution in a Gem.
