require File.dirname(__FILE__) + '/lib/common.rb'

class MountedApp < Sinatra::Base

  set   :app_file,  __FILE__
  set   :logging,   development?
  set   :static,    true
  set   :haml,      {:format => :html5}


  ['/', '/index'].each do |path|
    get path do
      @installed_packages = Package.all(:installed_version.gt => "")
      @updated_packages = Package.all(:conditions =>['"installed_version" > \'\' and "installed_version" <> "version"'])
      haml :index
    end
  end

  post "/search" do
    @packages = Package.all(:name.like => "%#{params[:package_name]}%")
    haml "packages/index".to_sym
  end

  post "/system/:package_id" do
    if params[:action].to_s.downcase == "update" then
      @ipkg_text = Ipkg.update
    else
      pkg = Package.get(params[:package_id].to_i)
      if pkg then
        Ipkg.new(params[:action].to_s.downcase, pkg.name, "myrouter.homelinux.net", 47258)
      else
        @ipkg_text = "No package found!"
        haml :ipkg
      end
    end
  end

  get '/updated' do
    @packages = Package.all(:conditions =>['"installed_version" > \'\' and "installed_version" <> "version"'])
    haml "packages/index".to_sym
  end

  get '/installed' do
    @packages = Package.all(:installed_version.gt => "")
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

