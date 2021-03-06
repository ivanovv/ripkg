$LOAD_PATH << File.join(File.dirname(__FILE__), '..', '..')
$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'rubygems'
# Gems
require 'sinatra'
begin; require 'sinatras-hat'; rescue LoadError; end
require 'lib/sinatras-hat/lib/sinatras-hat.rb' unless defined? Sinatra::Hat
require 'haml'

# Utils
require 'ipkg'

# Models
require 'model'


module Sinatra
  module Hat
    if !Maker.new(Maker).options.include?(:mounted_template_engine) then
     puts "need to monkey patch sinatras hat"

     class Maker
       def options
          @options ||= {
            :only => Set.new(Maker.actions.keys),
            :parent => nil,
            :finder => proc { |model, params| model.all },
            :record => proc { |model, params| model.send("find_by_#{to_param}", params[:id]) },
            :protect => [ ],
            :formats => { },
            :mounted_template_engine => :haml,
            :to_param => :id,
            :credentials => { :username => 'username', :password => 'password', :realm => "The App" },
            :authenticator => proc { |username, password| [username, password] == [:username, :password].map(&credentials.method(:[])) }
          }
        end
      end

      class Response
        delegate :options, :to => :maker
        def render(action, render_options={})
            render_options.each { |sym, value| @request.send(sym, value) }
            @request.send(options[:mounted_template_engine], "#{maker.prefix}/#{action}".to_sym)
          rescue Errno::ENOENT
            no_template! "Can't find #{File.expand_path(File.join(views, action.to_s))}.#{options[:mounted_template_engine].to_s}"
        end
      end
    end
  end
end


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

