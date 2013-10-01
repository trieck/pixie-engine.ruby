# An anchor is a virtual term-location identifier in the document repository.
# Each anchor is 8-bytes long. The bit-layout of an anchor is:
#  -------------ANCHOR-------------
#  63.....48 47........16 15......0
#  {FILENUM} {FILEOFFSET} {WORDNUM}
#  ---------DOCID--------|---------
#  FILENUM      : file # in repository (16-bits, 32,767 max number of files)
#  FILEOFFSET   : offset into file where record is located (32-bits,
#                 max file size ~2GB)
#  WORDNUM      : word number of term in field (16-bits,
#                 32,767 max words per field)
#  DOCID        : The upper 48-bits of the anchor represents the document id.

class Anchor
  include Comparable

  FILENUM_BITS = 16
  OFFSET_BITS = 32
  WORDNUM_BITS = 16

  attr_reader :anchorid

  def initialize(anchorid)
    @anchorid = anchorid
  end

  def docid
    # need an unsigned right shift here like >>>
    (@anchorid >> WORDNUM_BITS) & 0x7FFFFFFF
  end

  def wordnum
    @anchorid & 0x7FFF
  end

  def self.make_anchor(filenum, offset, wordnum)
    raise unless (filenum < (1 << FILENUM_BITS) - 1)
    raise unless (offset < (1 << OFFSET_BITS) - 1)
    raise unless (wordnum < (1 << WORDNUM_BITS) - 1)

    anchorid = (filenum & 0x7FFF) << (OFFSET_BITS + WORDNUM_BITS)
    anchorid |= (offset & 0x7FFFFFFF) << WORDNUM_BITS
    anchorid |= wordnum & 0x7FFF
    anchorid
  end

  def <=>(other)
    [self.anchorid] <=> [other.anchorid]
  end

end
