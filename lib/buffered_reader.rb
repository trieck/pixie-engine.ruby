class BufferedReader
  def initialize(io, size)
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
