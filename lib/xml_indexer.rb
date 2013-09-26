require 'index'
require 'index_fields'
require 'repository'
require 'nokogiri'

class XMLIndexer < Nokogiri::XML::SAX::Document

  def initialize
    @repos = Repository.instance
    @index = Index.new
    @elements = []
    @position = 0
    @filenum = 0
  end

  def start_element name, attrs = []
    puts "#{name} started!"
  end

  def end_element name
    puts "#{name} ended"
  end

  def characters string
    puts "characters: #{string}"
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
    @position = 0
    files.each do |file|
      load_file(file)
    end
    @filenum += 1
  end

  def load_file(file)
    parser = Nokogiri::XML::SAX::Parser.new(self)
    parser.parse_file(file)
  end

  def expand(dir)
    Dir.glob("#{dir}/**/*.xml")
  end
end
