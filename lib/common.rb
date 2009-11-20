$LOAD_PATH << File.join(File.dirname(__FILE__), '..', '..')
$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'rubygems'
require 'sinatra'
require 'lib/sinatras-hat'
require 'haml'
require 'ipkg'

# Models
require 'model'

def plural(count, singular, plural)
    count == 1 ? singular : plural
end 

class Fixnum
  def to_filesize(precision = 1)
      bytes = self
      case 
        when bytes < 1024; "%d #{plural(bytes, 'byte', 'bytes')}" % bytes
        when bytes < 1048576; "%.#{precision}f #{plural((bytes / 1024), 'kilobyte', 'kilobytes')}" % (bytes / 1024)
        when bytes < 1073741824; "%.#{precision}f #{plural((bytes / 1048576), 'megabyte', 'megabytes')}" % (bytes / 1048576)
        when bytes >= 1073741824; "%.#{precision}f #{plural((bytes / 1073741824), 'gigabyte', 'gigabytes')}" % (bytes / 1073741824)
      end
  end
end

