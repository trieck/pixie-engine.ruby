require 'concordance'

class Index

  def initialize
    @concord = Concordance.new
  end

  def insert(term, anchor)
    @concord.insert(term, anchor)
  end

  def write(db, fields)
  end

end
