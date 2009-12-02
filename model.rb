require 'rubygems'
require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'
require 'dm-aggregates'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/test.sqlite3")

class Package
  include DataMapper::Resource

  property :id,                 Serial                  # primary serial key
  property :name,               String,   :nullable => false,   :length => 0..255,  :unique => true,  :index => :name,  :unique_index => true
  property :description,        Text,     :lazy => false
  property :depends,            String,   :length => 0..255
  property :suggests,           String,   :length => 0..255
  property :version,            String,   :nullable => false,   :length => 0..255
  property :installed_version,  String
  property :maintainer,         String,   :nullable => false,   :length => 0..255
  property :size,               Integer,  :nullable => false,   :default => 0
  property :filename,           String,   :nullable => false,   :length => 0..255
  property :source,             String,   :nullable => false,   :length => 0..255
  property :status,             String,   :length => 0..255

  property :installed_at,       DateTime
  property :uninstalled_at,     DateTime
  property :created_at,         DateTime
  property :updated_at,         DateTime

  default_scope(:default).update(:order => [:name.asc])

  belongs_to :section
end

class Section
  include DataMapper::Resource

  property :id,                 Serial                  # primary serial key
  property :name,               String,   :nullable => false,   :length => 0..255,  :unique => true,  :index => :name,  :unique_index => true
  
  default_scope(:default).update(:order => [:name.asc])

  has n, :packages
end

DataMapper.auto_upgrade!
DataMapper.logger.set_log('log/dm.log', :debug," ~ ", true) if (ENV['RACK_ENV'] || :development).to_sym != :production