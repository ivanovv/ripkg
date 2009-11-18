require 'rubygems'
require 'model'

class ListParser

  def initialize (lists_path, record_delimiter)
    @lists_path = lists_path
    @record_delimiter = record_delimiter
  end

  def parse    
    Dir[@lists_path + "/*"].each do  |list_path| 
      if !File.directory?(list_path) then
        puts list_path
        File.open(list_path).each(@record_delimiter) do |package|
          package.strip!
          yield(package) if package.length > 0
        end
      end      
    end
  end
    
end