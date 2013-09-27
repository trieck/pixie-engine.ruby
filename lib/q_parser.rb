require 'pushback_reader'

class QParser

  BUFFER_SIZE = 8192

  :undeftag # undefined tag
  :begintag # begin tag
  :endtag # end tag
  :emptytag # empty tag
  :proctag # processing instruction tag
  :decltag # declaration tag

  # position in input stream
  attr_accessor :position

  def initialize
  end

  def parse (file)
    @reader = PushbackReader.new File.new(file, 'rb'), BUFFER_SIZE
    parse_doc
  end

  def parse_doc
    while c = @reader.read

    end
  end

end