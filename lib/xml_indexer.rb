require 'index'
require 'index_fields'
require 'repository'
require 'q_parser'

class XMLIndexer < QParser

  def initialize
    @repos = Repository.instance
    @index = Index.new
    @elements = []
    @filenum = 0
  end

  def value(value)
    puts "value: #{value}"
  end

  def start_element name, tag
    puts "#{name} started: tag: #{tag}"
  end

  def end_element
    puts "element ended"
  end

  def load(db, fields)
    @fields = IndexFields.from_fields(fields)
    dir = @repos.map_path(db)
    files = expand(dir)
    if files.length == 0
      raise IOError, "no content files found in #{dir}."
    end
    load_files(files)
    @index.write(db, @fields)
  end

  def load_files(files)
    files.each do |file|
      load_file(file)
    end
    @filenum += 1
  end

  def load_file(file)
    self.position = 0
    parse(file)
  end

  def expand(dir)
    Dir.glob("#{dir}/**/*.xml")
  end
end
