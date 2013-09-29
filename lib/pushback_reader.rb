require 'buffered_reader'

class PushbackReader  < BufferedReader

  BUFFER_SIZE = 8192

  def initialize(io, size)
    super(io, BUFFER_SIZE)
    @pos = @size = size
    @buf = Array.new(size)
  end

  def read
    if @pos < @buf.length
      c = @buf[@pos]
      @pos += 1
      c
    else
      super
    end
  end

  def unread(c)
    if @pos == 0
      raise IOError, 'Pushback buffer overflow'
    end
    @buf[@pos -= 1] = c.chr
  end

  def unreads(buff)
    if buff.length > @pos
      raise IOError, 'Pushback buffer overflow'
    end

    @pos -= buff.length

    n = 0
    buff.split("").each do |b|
      @buf[@pos+n] = b.chr
      n += 1
    end
  end
end