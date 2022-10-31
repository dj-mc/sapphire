#!/usr/bin/env ruby
# lex -> parse -> generate

require_relative("./tokenizer.rb")
require_relative("./parser.rb")

tokens = Tokenizer.new(File.read("source.sfr")).tokenize
puts tokens.map(&:inspect).join("\n")

tree = Parser.new(tokens).parse
p tree
