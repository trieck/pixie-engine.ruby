require 'pushback_reader'

class Tokenizer
  BUFFER_SIZE = 8192

  def initialize(str)
    io = StringIO.new(str)
    @reader = PushbackReader.new(io, BUFFER_SIZE)
    @buffer = ''
  end

  def get_token
    nil # override
  end

  def lookahead
    tok = get_token
    unread # unread the token buffer
    tok
  end

  # unread the entire token buffer
  def unread
    unreadn(@buffer.length)
  end

  def unreadn(n)
    m = [@buffer.length, n].min

    i = 0
    @buffer.reverse.each_char do |c|
      if i == m
        break
      end
      @reader.unread(c)
      i += 1
    end

    @buffer = @buffer[0..-(m+1)]
  end

  def clear
    @buffer.clear
  end

  def read
    if (c = @reader.read)
      @buffer << c
      c.chr
    end
  end


end