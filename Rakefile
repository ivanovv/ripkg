require 'rubygems'
require 'net/ftp'
require 'model'
require 'list_parser'
require 'package_parser'


ROUTER_NAME = 'myrouter.homelinux.net'
ROUTER_DIR = '/ipkg'
ROUTER_LIST_DIR = 'lists'
LOCAL_TMP_DIR = './tmp'
STATUS_FILE = 'status'
OPTIONS_FILE = 'ipkg_list_path'


task :default => [:load_data, :parse_data]

desc "load data from router"
task :load_data do
  puts "Start data download"
  ftp = Net::FTP.new(ROUTER_NAME)
  ftp.passive = true
  ftp.login
  ftp.chdir(ROUTER_DIR)
  ftp.gettextfile(STATUS_FILE, File.join(LOCAL_TMP_DIR, STATUS_FILE))
  ftp.chdir(ROUTER_LIST_DIR)

  local_dir = File.join(LOCAL_TMP_DIR, ROUTER_LIST_DIR)
  Dir.mkdir(local_dir) unless File.exists?(local_dir)

  ftp.nlst.each do |ftp_file|
    local_file = File.join(local_dir, ftp_file)
    File.delete(local_file) if File.exists?(local_file)
    ftp.gettextfile(ftp_file, local_file)
  end
  puts "Data downloaded successfully"
end

desc "parse data from router"
task :parse_data do

  if File.exist?(OPTIONS_FILE)
    ipkg_list_path = File.read(OPTIONS_FILE).chomp
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
end


