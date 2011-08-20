require 'bundler/setup'
require 'sinatra'
require 'sass'
require 'compass'
require 'mongo_mapper'
require 'mustache/sinatra'

MongoMapper.database = 'mongolog'

class Post
  include MongoMapper::Document

  key :title, String
  key :body, String

  timestamps!
end


class App < Sinatra::Base
  register Mustache::Sinatra
  require_relative 'views/layout'

  set :mustache, { :views => 'views/', :templates => 'templates/' }
  set :method_override, true

  configure do
    config_file = File.join(Sinatra::Application.root, 'config.rb')
    Compass.add_project_configuration(config_file)
  end

  get '/stylesheets/:name.css' do
    content_type 'text/css', :charset => 'utf-8'
    scss(:"stylesheets/#{params[:name]}", Compass.sass_engine_options )
  end


  get '/' do
    @posts = Post.sort(:updated_at.desc).all
    mustache :index
  end

  get '/new' do
    @post = Post.new
    mustache :new
  end

  post '/' do
    @post = Post.new(params[:post])
    @post.save
    redirect '/'
  end

  get '/:id' do |id|
    @post = Post.find(id)
    mustache :show
  end

  get '/:id/edit' do |id|
    @post = Post.find(id)
    mustache :edit
  end

  put '/:id' do |id|
    @post = Post.find(id)
    @post.update_attributes(params[:post])
    mustache :show
  end

  delete '/:id' do |id|
    @post = Post.find(id)
    @post.delete
    redirect '/'
  end

end

