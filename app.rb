require 'sinatra'
require 'sinatra/json'

set :protection, :except => [:json_csrf]

get '*' do
  #erb :index, locals: {env: env}
  json({"ip" => env['REMOTE_ADDR'], "agent" => env['HTTP_USER_AGENT']})
end
