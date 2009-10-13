require 'rubygems'
require 'model'
require 'list_parser'
require 'package_parser'
require 'sinatra'
require 'haml'


get '/list/section/:id' do
  #@comics = Comics.first
  @section = Section.get(params[:id])
  if @section != nil then
    @packages = @section.packages.all
  end
  haml :section_show
end


get '/list/sections' do
  @sections = Section.all
  haml :list_sections
end


get '/list/packages' do
  @packages = Package.all
  haml :list_packages
end


get '/:id' do    
  @package = Package.get(params[:id]) || Package.first
  haml :package
end


['/', '/index'].each do |path|
  get path do  
    haml :index
  end
end