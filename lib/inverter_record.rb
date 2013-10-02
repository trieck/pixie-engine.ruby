class InverterRecord
  include Comparable
  attr_accessor term, buffer

  def <=>(other)
    [term] <=> [other.term]
  end

end