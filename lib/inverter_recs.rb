class InverterRecs
  private_class_method :new

  def initialize(size)
    @size = size
    @records = Array.new(size)
  end

  def self.allocate(size)
    new(size)
  end

  def empty?(index)
    raise ArgumentError unless (index > 0 && index < @records.length)
    @records[index].nil?
  end

  def term(index)
    raise ArgumentError unless (index > 0 && index < @records.length)
    @records[index].term
  end

  def anchors(index)
    raise ArgumentError unless (index > 0 && index < @records.length)
    @records[index].buffer
  end

  def put(index, term)
    raise ArgumentError unless (index > 0 && index < @records.length)
    raise unless @records[index] == null

    @records[index] = InverterRecord.new
    @records[index].buffer = Array.new
    @records[index].term = term
  end

  def insert(index, anchor)
    raise ArgumentError unless (index > 0 && index < @records.length)
    raise unless @records[index] != null

    buffer = @records[index].buffer
    if buffer.length > 0
      if buffer[buffer.length-1] == anchor
        return # exists
      end
      raise unless buffer[buffer.length-1] < anchor
    end

    buffer.append(anchor)
  end

  def compact
    j = 0

    @records.each_index do |i|
      if @records[i]
        next
      end

      while j < @records.length
        if j > i && @records[j]
          break
        end
        j += 1
      end

      if j >= @records.length
        break
      end

      @records[i] = @records[j]
      @records[j] = nil
    end
  end

  def sort
    @records.sort!
  end

  def clear
    @records.each_index do |i|
      @records[i] = nil
    end
  end

end