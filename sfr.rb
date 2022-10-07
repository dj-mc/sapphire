#!/usr/bin/env ruby
# lex -> parse -> generate

Token = Struct.new(:type, :value)

class Tokenizer
  TOKEN_TYPES = [
    # 2D array of symbols
    # [:type of symbol and its regex]
    [:def, /\bdef\b/],
    [:end, /\bend\b/],
    [:var, /\b[a-zA-Z]\b/],
    [:int, /\b[0-9]+\b/],
    [:lpa, /\(/],
    [:rpa, /\)/],
  ]

  def initialize(src_code)
    # Source code to be tokenized
    @code = src_code
  end

  def tokenize
    until @code.empty?
      TOKEN_TYPES.each do |symbol, rgx|
        # Regex matching start of string
        rgx = /\A(#{rgx})/ # The #{rgx} is interpolated
        # Use \A to match start of string instead of ^ (start of line).

        if @code =~ rgx # Match @code against rgx
          # First capture group of rgx
          value = $1
          @code = @code[value.length..-1] # Truncate captured token from beginning of string
          # Construct new token from captured token's value
          Token.new(symbol, value)
          return Token.new(symbol, value)
        end
      end
    end
    raise RuntimeError.new(
      "Couldn't match token on #{@code.inspect}"
    )
  end
end


tokens = Tokenizer.new(File.read("source.sfr")).tokenize
p tokens
