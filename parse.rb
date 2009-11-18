require 'rubygems'
require 'model'
require 'list_parser'
require 'package_parser'

OPTIONS_FILE = 'ipkg_list_path'

if File.exist?(OPTIONS_FILE)
  ipkg_list_path = File.read(OPTIONS_FILE)
else
  ipkg_list_path ||='/opt/lib/ipkg'
end

puts "Parsing started"

list_parser = ListParser.new( File.join(ipkg_list_path, "lists"), "\n\n\n" )

list_parser.parse do |package|
  parsed_package = PackageParser::parse_package(package)

  if parsed_package[:package][:name].to_s != ""
    
    section = Section.first(parsed_package[:section])
    if !section then
      section = Section.new(parsed_package[:section])
      section.save
    end

    package = section.packages.first(:name => parsed_package[:package][:name])

    if !package then
      package = section.packages.create(parsed_package[:package])
      package.save
    else
      package.attributes = parsed_package[:package]
      package.save if package.dirty?
    end

  end

end



status_parser = ListParser.new(ipkg_list_path, "\n\n")
status_parser.parse do |package|
  parsed_package = PackageParser::parse_package(package)
  if parsed_package[:package][:name].to_s != ""    
    package = Package.first(:name => parsed_package[:package][:name])
    if package then
      package.installed_version = parsed_package[:package][:version]
      package.status = parsed_package[:package][:status]
      package.save
    end
  end
end

puts "Parsing finished"