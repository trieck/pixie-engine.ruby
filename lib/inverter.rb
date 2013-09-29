require 'inverter_recs'

class Inverter

  MAX_COUNT = 100000 # maximum number of index records

  attr_reader :count

  def initialize
    @records = InverterRecs.new # hash table of records
    @count = 0 # number of records in table
  end

  def is_full?
    @count >= MAX_COUNT
  end

  def compact
    @records.compact
  end

  def clear
    @records.clear
    @count = 0
  end

  def write(io)
    compact
    sort

    @count.times do |i|
      term = @records.term(i)
      anchors = @records.anchors(i)

      # write term
      # write anchors.position

    end

  end

  def insert(term, anchor)

  end

end