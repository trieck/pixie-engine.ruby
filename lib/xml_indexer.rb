require 'index'
require 'index_fields'
require 'repository'
require 'q_parser'
require 'anchor'
require 'lexer'

class XMLIndexer < QParser

  def initialize
    @repos = Repository.instance
    @index = Index.new
    @elements = []
    @filenum = 0
    @offset = 0
  end

  def value(value)
    unless top_level? && value.strip.length > 0
      return
    end

    field = @elements.last
    lexer = Lexer.new(value)

    i = 0
    while (tok = lexer.get_token).length > 0
      term = "#{field}:#{tok}"
      anchor = Anchor.anchor_id(@filenum, @offset, i)
      @index.insert(term, anchor)
      i += 1
    end
  end

  def start_element(name, tag)
    @elements.push name
    if name == "record"
      @offset = [0, self.position - tag.length].max
      raise unless (@offset < (1 << Anchor::OFFSET_BITS - 1))
    end
  end

  def end_element
    @elements.pop()
  end

  def load(db, fields)
    @fields = IndexFields.from_fields fields
    dir = @repos.map_path db
    files = expand dir
    if files.length == 0
      raise IOError, "no content files found in #{dir}."
    end
    load_files files
    @index.write db, @fields
  end

  def load_files(files)
    files.each do |file|
      load_file file
    end
    @filenum += 1
  end

  def load_file(file)
    self.position = 0
    parse file
  end

  def expand(dir)
    Dir.glob "#{dir}/**/*.xml"
  end

  def top_level?
    if @elements.size == 0
      return false
    end

    @fields.top_level? @elements.last
  end

end
