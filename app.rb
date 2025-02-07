# encoding: UTF-8
require 'rubygems'
require 'sinatra'
require 'active_record'
require 'yaml'
require 'dotenv/load'
require 'erb'

set :database_file, "config/database.yml"
set :public_folder, 'static'

configure do
  # http://recipes.sinatrarb.com/p/middleware/rack_commonlogger
  file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
  file.sync = true
  use Rack::CommonLogger, file
end

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])

class App < ActiveRecord::Base
end

class String
  def blank?
    self == nil || self == ''
  end
end

get "/" do
  @apps = App.all
	erb :index
end

post "/submit" do
	@app = App.new(params[:app])
	if @app.save
		redirect "/"
	else
		"Sorry, there was an error!"
	end
end

get "/robots.txt" do
  %{User-agent: *\nDisallow: /}
end

get "/ip" do
  request.ip
end

not_found do
  'This is nowhere to be found.'
end
