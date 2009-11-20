require File.dirname(__FILE__) + '/lib/common.rb'

class MountedApp < Sinatra::Base
  set :app_file, __FILE__
  set :logging, true
  set :static, true
  set :haml, {:format => :html5 }


  get '/' do
    "You created a post, and this is a custom response."
  end

  get '/index' do
    haml :index
  end

  post "/search" do
    @packages = Package.all(:name.like => "%#{params[:package_name]}%")
    #@packages = Package.all(:conditions =>["name like ?", "%#{params[:package_name]}%"])
    haml "packages/index".to_sym
  end


  get '/updated' do
    @packages = Package.all(:conditions =>['"installed_version" > "" and "installed_version" <> "version"'])
    haml "packages/index".to_sym
  end

  get '/installed' do
    @packages = Package.all(:conditions =>['"installed_version" > ""'])
    haml "packages/index".to_sym
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