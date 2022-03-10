#!/usr/bin/env ruby
# lex -> parse -> generate

class Tokenizer
  TOKEN_TYPES = [
    [:def, /\bdef\b/],
    [:end, /\bend\b/],
    [:var, /\b[a-zA-Z]\b/],
    [:int, /\b[0-9]+\b/],
    [:lpa, /\(/],
    [:rpa, /\)/],
  ]

  def initialize(src_code)
    @code = src_code
  end

  def tokenize
    until @code.empty?
      TOKEN_TYPES.each do |type, re|
        re = /\A(#{re})/
        if @code =~ re
          value = $1
          @code = @code[value.length..-1]
          Token.new(type, value)
          return Token.new(type, value)
        end
      end
    end
    raise RuntimeError.new(
      "Couldn't match token on #{@code.inspect}"
    )
  end
end

Token = Struct.new(:type, :value)

tokens = Tokenizer.new(File.read("source.sfr")).tokenize
p tokens
