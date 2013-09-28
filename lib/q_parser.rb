require 'pushback_reader'

class QParser

  BUFFER_SIZE = 100

  :undeftag # undefined tag
  :begintag # begin tag
  :endtag # end tag
  :emptytag # empty tag
  :proctag # processing instruction tag
  :decltag # declaration tag

  # position in input stream
  attr_accessor :position

  def initialize
    @type = :undeftag
    @position = 0
  end

  def parse (file)
    @reader = PushbackReader.new File.new(file, 'rb'), BUFFER_SIZE
    parse_doc
  end

  def parse_doc
    while c = read
      buffer = lookahead(3)
      unget(c)

      if c != '<'
        value get_value
        next
      end

      case buffer[0]
        when '/' # end tag
        when '!' # xml comment
        else
      end
    end
  end

  def read
    c = @reader.read
    @position += 1
    c
  end

  # lookahead n characters
  def lookahead(n)
    # doesn't alter position

    buffer = Array.new(n)

    i = 0
    while (c = @reader.read) && i < n
      buffer[i] = c.chr
      i += 1
    end

    # unread the characters read
    @reader.unreadv(buffer, 0, i)

    buffer.join
  end

  def unget(c)
    @reader.unread(c)
    @position -= 1
  end

  def get_value
    value = String.new

    while c = read
      case c
        when '<' # tag
          unget(c)
          value
        else
          value << c
      end
    end
    value
  end
end