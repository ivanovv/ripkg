$LOAD_PATH << File.join(File.dirname(__FILE__), '..', '..')
$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'rubygems'
require 'sinatra'
require 'lib/sinatras-hat'
require 'haml'
require 'pp'

# Models
require 'model'
