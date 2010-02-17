require 'rubygems'
require 'model'

class ListParser

  def initialize (list_path, record_delimiter)
    @list_path = list_path
    @record_delimiter = record_delimiter
  end

  def parse
    if File.directory? @list_path
      files_to_parse = Dir[@list_path + "/*"]
    else
      files_to_parse = []; files_to_parse << @list_path
    end
    files_to_parse.each do |list_path|
      if !File.directory?(list_path) then
        puts "Opening file: #{list_path}"
        File.open(list_path).each(@record_delimiter) do |package|
          package.strip!
          yield(package) if package.length > 0
        end
      end
    end
  end

end

