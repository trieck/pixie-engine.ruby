class PushbackReader

  def initialize(io, size)
    unless io.kind_of? IO
      raise ArgumentError, "argument #{io.inspect} must be of type IO."
    end
    @io = io
    @pos = @size = size
    @buf = Array.new(size)
  end

  def read
    if @pos == @size
      s = ""; @pos = 0
      if @io.read(@size, s).nil?
        nil
      else
        @buf = s.bytes
        @buf[0]
      end
    else
      c = @buf[@pos]
      @pos += 1
      c
    end
  end

  def unread(c)
    if @pos == 0
      raise IOError, "Pushback buffer overflow"
    end
    @buf[@pos -= 1] = c
  end

end