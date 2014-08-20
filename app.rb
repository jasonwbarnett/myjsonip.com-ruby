require 'sinatra'
require 'sinatra/json'
require 'yaml'

set :protection, :except => [:json_csrf]

helpers do
  def gen_ip(env)
    body = {"ip" => env['REMOTE_ADDR']}
  end

  def gen_agent(env)
    body = {"agent" => env['HTTP_USER_AGENT']}
  end

  def gen_all(env)
    ip    = gen_ip(env)
    agent = gen_agent(env)

    properties = [ip, agent]

    body = properties.inject({}) {|memo,x| memo.merge!(x); memo}
  end
end

get %r{/(robots\.txt|favicon\.ico)} do
end

get %r{/all/ya?ml}i do
  content_type :yaml
  body = gen_all(env)
  body.to_yaml
end

get '/all*' do
  body = gen_all(env)
  json(body)
end

get %r{/agent/ya?ml}i do
  content_type :yaml
  body = gen_agent(env)
  body.to_yaml
end

get '/agent*' do
  body = gen_agent(env)
  json(body)
end

## Respond with ip via YAML be default
get %r{/ya?ml.*}i do
  content_type :yaml
  body = gen_ip(env)
  body.to_yaml
end

## Respond with JSON by default
get '*' do
  body = gen_ip(env)
  json(body)
end

