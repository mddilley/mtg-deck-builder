require 'bundler'
Bundler.require

require 'open-uri'
require 'json'
require 'sinatra'
require 'sinatra/flash'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "db/development.sqlite3"
)

require_all 'app'
