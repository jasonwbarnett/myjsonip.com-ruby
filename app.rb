require 'sinatra'
require 'sinatra/json'
require 'yaml'
require 'action_view'
require 'active_support/core_ext'

set :show_exceptions, true
set :protection, :except => [:json_csrf]

helpers do
  def get_format(params)
    rec = params[:format]
    case rec
      when 'json'
        format = 'json'
      when 'yaml', 'yml'
        format = 'yaml'
      when 'xml'
        format = 'xml'
      else
        format = 'json'
    end
   format
  end

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


get '/all/?' do
  format = get_format(params)
  content_type format
  body = gen_all(env)
  body.send("to_#{format}")
end

get '/all/:format/?' do
  format = get_format(params)
  content_type format
  body = gen_all(env)
  body.send("to_#{format}")
end

get '/ip/?' do
  format = get_format(params)
  content_type format
  body = gen_ip(env)
  body.send("to_#{format}")
end

get '/ip/:format/?' do
  format = get_format(params)
  content_type format
  body = gen_ip(env)
  body.send("to_#{format}")
end

get '/agent/?' do
  format = get_format(params)
  content_type format
  body = gen_agent(env)
  body.send("to_#{format}")
end

get '/agent/:format/?' do
  format = get_format(params)
  content_type format
  body = gen_agent(env)
  body.send("to_#{format}")
end

get '*' do
  body = gen_ip(env)
  json(body)
end

