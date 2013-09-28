require 'pushback_reader'

class QParser

  BUFFER_SIZE = 100
  UNDEFTAG = 0 # undefined tag
  BEGINTAG = 1 # begin tag
  ENDTAG = 2 # end tag
  EMPTYTAG = 4 # empty tag
  PROCTAG = 8 # processing instruction tag
  DECLTAG = 16 # declaration tag
  EMPTYTAGS = (EMPTYTAG | PROCTAG | DECLTAG)

  # position in input stream
  attr_accessor :position

  def initialize
    @type = UNDEFTAG
    @position = 0
  end

  def parse (file)
    @reader = PushbackReader.new File.new(file, 'rb'), BUFFER_SIZE
    parse_doc
  end

  def parse_doc
    until (c = read).nil?
      buffer = lookahead(3)
      unget(c)

      if c != '<'
        value get_value
        next
      end

      if buffer[0] == '/' # end tag
        save = @type
        end_tag
        if save == BEGINTAG
          end_element
        end
        next
      elsif buffer[0] == '!'
        if buffer[1] == '-' && buffer[2] == '-'
          get_comment
          @type = UNDEFTAG
        end
      end

      tag = start_tag
      @type = tag_type(tag)
      name = tag_name(tag)
      start_element name, tag

      if @type == EMPTYTAG
        end_element
      end
    end
  end


  def read
    if (c = @reader.read).nil?
      nil
    else
      @position += 1
      c.chr
    end
  end

  # lookahead n characters
  def lookahead(n)
    # doesn't alter position

    buffer = String.new

    i = 0
    while i < n
      if (c = @reader.read).nil?
        break
      end
      buffer << c.chr
      i += 1
    end

    # unread the characters read
    @reader.unreads(buffer)

    buffer
  end

  def unget(c)
    @reader.unread(c)
    @position -= 1
  end

  def get_value
    value = String.new

    until (c = read).nil?
      case c
        when '<' # tag
          unget(c)
          return value
        else
          value << c
      end
    end
    value
  end

  def start_tag

    tag = String.new

    until (c = read).nil?
      if c == '>'
        tag << c
        break
      end
      tag << c
    end

    tag
  end

  def end_tag
    if (@type & EMPTYTAGS) != 0
      @type = UNDEFTAG
      return ""
    end

    tag = String.new

    until (c = read).nil?
      if c == '>'
        tag << c
        break
      end
      tag << c
    end

    @type = UNDEFTAG

    tag
  end

  def tag_type(tag)
    i = 0
    tag.split("").each do |c|
      if c == '<'
        if i < tag.length-1 && tag[i+1] == '!'
          return DECLTAG
        end
        if i < tag.length-1 && tag[i+1] == '?'
          return PROCTAG
        end
        if i < tag.length-1 && tag[i+1] == '/'
          return ENDTAG
        end
      elsif c == '>'
        if i > 0 && tag[i-1] == '/'
          return EMPTYTAG
        end
        return BEGINTAG
      end
      i += 1
    end
    UNDEFTAG
  end

  def tag_name(tag)
    name = String.new

    tag.split("").each do |c|
      case c
        when ' ', '\t', '\r', '\n', '>', '/'
          return name
        when '<', '!', '?'
          next
        else
          name << c
      end
    end

    name
  end

  def get_comment
    comment = String.new

    until (c = read).nil?
      buffer = lookahead(2)
      if c == '-' && buffer[0] == '-' && buffer[1] == '>'
        comment << c # -->
        comment << read
        comment << read
        break
      end
      comment << c
    end

    comment
  end
end



