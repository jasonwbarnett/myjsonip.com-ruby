require 'sinatra'
require 'sinatra/json'
require 'yaml'

set :protection, :except => [:json_csrf]

get %r{/(robots\.txt|favicon\.ico)} do
end

body = {"ip" => env['REMOTE_ADDR'], "agent" => env['HTTP_USER_AGENT']}

get %r{/ya?ml} do
  body.to_yaml
end

## Respond with JSON by default
get '*' do
  json(body)
end
