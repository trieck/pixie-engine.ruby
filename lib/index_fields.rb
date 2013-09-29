require 'index_header'

class IndexFields
  include Enumerable
  private_class_method :new
  attr_accessor :fields

  def self.from_db(db)
    inst = new
    inst.fields = []
    repos = Repository.instance
    index = repos.get_index_path(db)

    File.open(index, 'rb') do |io|
      header = IndexHeader.read(io)
      (0..header.num_fields - 1).each do |i|
        inst.fields << header.fields[i].name
      end
    end
    inst
  end

  def self.from_fields(fields)
    inst = new
    inst.fields = fields.sort
    inst
  end

  def size
    fields.size
  end

  def top_level?(field)
    fields.include? field
  end

  def each(&block)
    fields.each do |member|
      block.call(member)
    end
  end

end
