require 'sinatra'
require 'sinatra-websocket'
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
    next if role == 'wolf' && @counts[role] > 2    # 狼は３人
    next if role == 'madman' && @counts[role] > 1  # 狂人は１人
    next if role == 'teller' && @counts[role] > 1
    next if role == 'psychic_mage' && @counts[role] > 1
    next if role == 'knight' && @counts[role] > 1
    next if role == 'villager' && @counts.map < 6
    @counts[role] ||= 0
    @counts[role] += 1
    return role
  end
end

def try_kill()

end

get '/' do
  slim :index
end

get '/wolf' do
  slim :wolf
end

get '/noon' do
  unless params[:users].nil?
    config[:users] = params[:users] if params[:users]
    config[:nighttime] = params[:nighttime] if params[:nighttime]
    config[:noontime] = params[:noontime] if params[:noontime]
    users = {}
    config[:users].each_with_index do |user, index|
      users[index] = {role: deside_role, name: user}
    end
    config[:users] = users
  end

  @config = config
  p @config.to_json
  slim :noon
end

get '/night' do
  @config = config
  p @config.to_json
  slim :night
end

get '/websocket' do
  if request.websocket?
    request.websocket do |ws|
      ws.onopen { settings.sockets << ws }
      ws.onmessage do |data|
        case data
        when 'change_to_night'
          # 票の集計処理
          # 狩人反映
          # プレイヤー一覧の送信
        when 'change_to_noon'
          # 占い結果の送信
          # 霊能の結果を送信
          # 狼の噛み結果の送信
          # ゲーム情報の送信
        when 'try_kill'
          # 噛み先の指定
        when 'try_defense'
          # 守り先の指定
        when 'select_telling'
          # 占いの実行
        else
          #
        end
      end
      ws.onclose { settings.sockets.delete(ws) }
    end
  end
end


