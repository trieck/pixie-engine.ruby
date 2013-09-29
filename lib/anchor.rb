# An anchor is a virtual term-location identifier in the document repository.
# Each anchor is 8-bytes long. The bit-layout of an anchor is:
# -------------ANCHOR-------------
#  63.....48 47........16 15......0
#  {FILENUM} {FILEOFFSET} {WORDNUM}
#  ---------DOCID--------|---------
#  FILENUM 	   :  file # in repository (16-bits, 32,767 max number of files)
#  FILEOFFSET	 :  offset into file where record is located (32-bits,
#                 max file size ~2GB)
#  WORDNUM     :  word number of term in field (16-bits,
#                 32,767 max words per field)
#  DOCID       :  The upper 48-bits of the anchor represents the document id.

class Anchor
  FILENUM_BITS = 16
  OFFSET_BITS = 32
  WORDNUM_BITS = 16

  def self.anchor_id(filenum, offset, wordnum)
  end

end
