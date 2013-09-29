require 'inverter'
require 'tempfile'

class Concordance

  def initialize
    @block = Inverter.new
    @tempfiles = []
  end

  def is_full?
    @block.is_full?
  end

  def block_save
    unless @block.count == 0
      return
    end

    file = Tempfile.new('conc')
    @tempfiles.add(file.path)
    @block.write(file)
  end

  def merge
    block_save

    if @tempfiles.size == 1
       return @tempfiles[0] # optimization
    end

    merger = ConcordMerge.new
    merger.merge(@tempfiles)

  end

  def insert(term, anchor)
    if is_full?
      block_save
    end
    @block.insert(term, anchor)
  end

end