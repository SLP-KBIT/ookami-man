require 'sinatra'
if development?
  require 'sinatra/reloader'
  require 'pry'
end

require 'json'
require 'slim'
require 'sass'

set :root, File.dirname(__FILE__)
set :public, File.dirname(__FILE__) << '/public'
# set :server, 'thin'
set :sockets, []

config = {}
users =  {}

ROLES = [
  :villager,    # 村人
  :wolf,        # 狼
  :madman,      # 狂人
  :teller,      # 占い師
  :psychic_mage # 霊能術師
].freeze

# @return String: role_name
def deside_role
  while true
    role = ROLES.sample
    @counts ||= {}
    next if role == 'wolf' && @counts[role] > 3    # 狼は３人
    next if role == 'madman' && @counts[role] > 1  # 狂人は１人
    next if role == 'teller' && @counts[role] > 1
    next if role == 'psychic_mage' && @counts[role] > 1
    next if role == 'villager' && @counts.map < 6
    @counts[role] ||= 0
    @counts[role] += 1
    return role
  end
end

get '/' do
  slim :index
end

get '/wolf' do
  erb :wolf
end

get '/noon' do
  config[:users] = params[:users] if params[:users]
  config[:nighttime] = params[:nighttime] if params[:nighttime]
  config[:noontime] = params[:noontime] if params[:noontime]
  config[:users].each { |user| users[user] = deside_role }

  @config = config
  slim :noon
end

get '/night' do
  @config = config
  slim :night
end

get '/websocket' do
  if request.websocket?
    request.websocket do |ws|
      ws.onopen { settings.game.add_client(ws) }
      ws.onmessage { |data| p data }
      ws.onclose { settings.sockets.delete(ws) }
    end
  end
end


