require 'sinatra'
require 'sinatra/json'
require 'yaml'

set :protection, :except => [:json_csrf]

get %r{/(robots\.txt|favicon\.ico)} do
end

def gen_body(env)
  body = {"ip" => env['REMOTE_ADDR'], "agent" => env['HTTP_USER_AGENT']}
end

get %r{/ya?ml} do
  content_type :yaml
  body = gen_body(env)
  body.to_yaml
end

## Respond with JSON by default
get '*' do
  body = gen_body(env)
  json(body)
end
