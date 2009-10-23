require File.dirname(__FILE__) + '/lib/common.rb'

class MountedApp < Sinatra::Base
  set :app_file, __FILE__
  set :logging, true
  set :static, true

  
  get '/' do
    "You created a post, and this is a custom response."
  end
  
  mount(Section) do
    mounted_template_engine :haml
    finder { |model, params| model.all }
    record { |model, params| model.first(:id => params[:id].to_i) }
    
    # Mount children as a nested resource
    mount(Package) do
      mounted_template_engine :haml      
      finder { |model, params| model.all }
      record { |model, params| model.first(:id => params[:id].to_i) }
    end
  end
end

MountedApp.run! if __FILE__ == $0