require 'rubygems'

class PackageParser

@regex = {:name => "Package",
          :version => "Version",
          :depends => "Depends",
          :section => "Section",
          #:architecture => "Architecture",
          :maintainer => "Maintainer", 
          :size => "Size",
          :filename => "Filename",
          :source => "Source",
          :description => "Description",
          :status => "Status"
          }

  def self.parse_package(package)
    lines = package.split("\r\n")
    @parsed_package = { :package => {}, :section => {} }
    
    lines.each do |line|
      @regex.each do |symbol, regex|
        if line =~ /#{regex}: (.*)$/
          if symbol != :section
            @parsed_package[:package][symbol] = $1
          else
            @parsed_package[:section] = {:name => $1}
          end
        end
      end      
    end
    @parsed_package
  end

end