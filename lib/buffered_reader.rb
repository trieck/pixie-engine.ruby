class BufferedReader
  def initialize(io, size)
    unless io.kind_of? IO
      raise ArgumentError, "argument #{io.inspect} must be of type IO."
    end
    @io = io
    @index = @bsize = size
    @buffer = Array.new(size)
  end

  def read
    if @index == @buffer.size
      s = ''
      if @io.read(@bsize, s).nil?
        nil
      else
        @buffer = s.bytes
        @index = 1
        @buffer[0]
      end
    else
      c = @buffer[@index]
      @index += 1
      c
    end
  end
end
