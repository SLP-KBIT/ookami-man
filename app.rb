require 'sinatra'
require 'sinatra/reloader' if development?

require 'json'
require 'slim'
require 'sass'

set :root, File.dirname(__FILE__)
set :public, File.dirname(__FILE__) << '/public'

get '/' do
  slim :index
end

get '/wolf' do
  erb :wolf
end
