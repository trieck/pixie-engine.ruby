require 'tokenizer'

class Lexer < Tokenizer

  def initialize(str)
    super(str)
  end

  def get_token
    clear

    token = ''

    while (c = read)
      if (c == '_' || c == '\'') && token.length
        token << c
      elsif c =~ /[[:alpha:]]/ || c =~ /[[:digit:]]/
        token << c.downcase
      elsif token.length > 0
        unreadn(1)
        return token
      end
    end
    token
  end

end