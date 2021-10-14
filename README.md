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
is enough passed argument in terminal. Then, it use `FileReader`
class to create a file handle refer to passed argument. Finally,
an instance of `LogAnalyzer` is created with running `analyze`
instance method of it.

In order to fulfill its task, `LogAnalyzer` does the following steps:

* Read log file and passes lines to `LinesFormatter`
* Send line_formatter with lines inside to different analyzers
* Each analyzer return array of objects with 
* Present stored data in the output

These behaviours which are implemented in `FileReader`, `Store` and
`Printer` class respectively, injected into `LogFileAnalyzer` class
as dependencies in instance initialization.

Utilizing this architecture helps in exchanging each dependency
class with another one which can present the same behaviour but in
another manner. For instance, an alternative file reader class could
deal with another format of log file while it fits in the same
architecture.

## To Do

The project has room for improvement:

* Add usage document to `./parser.rb` command.
* Parsing terminal argument utilizing a third party gem like
`optparse` will improve robustness with more capabilities.
* Improve efficiency of `Store` with cache mechanism.
* Provide an option for the terminal command to switch between total
and unique visits stat.
* Add more custom exception class with more detail to catch possible
exception while working with files.
* Encapsulate solution in a Gem.