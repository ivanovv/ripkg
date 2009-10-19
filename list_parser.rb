require 'rubygems'
require 'model'

class ListParser

  def initialize (lists_path, record_delimiter)
    @lists_path = lists_path
    @record_delimiter = record_delimiter
  end

  def parse(package_parser)
    @package_parser = package_parser
    Dir[@lists_path + "/*"].each { |list_path| parse_list(list_path) unless File.directory?(list_path) }
  end

  def parse_list(list_path)   
    File.open(list_path).each(@record_delimiter) do |package|
      package.strip!
      @package_parser.call(package) if package.length > 0
    end
  end
  
end