# Mongolog (Steps)

## Step one create Gemfile

    touch Gemfile
    echo "source :rubygems" >> Gemfile
    echo "gem 'sinatra'" >> Gemfile
    echo "gem 'mongo_mapper'" >> Gemfile
    echo "gem 'bson_ext'" >> Gemfile
    echo "gem 'mustache'" >> Gemfile
    echo "gem 'i18n'" >> Gemfile
    bundle install

## Step two create config.ru and app.rb

    touch config.ru
    echo "require 'app'" >> config.ru
    echo "run App" >> config.ru

    touch app.rb
    echo "require 'bundler/setup'" >> app.rb
    echo "require 'sinatra'" >> app.rb
    echo "require 'mongo_mapper'" >> app.rb
    echo "require 'mustache/sinatra'" >> app.rb

## Step three test sinatra

    vim app.rb

    # add the following to app.rb
    class App < Sinatra::Base
      get '/' do
        'hello world'
      end
    end

    # save
    # run rackup
    rackup

    # open a browser to localhost:9292

    # go back to the terminal and hit ctrl-c to shutdown rackup

## Step four build the blog model

We are going to create a mongo mapper document called Post, this will
hold all of our awesome blog posts.

    vim app.rb

    # add the following above the sinatra class

    MongoMapper.database = 'mongolog'

    class Post 
      include MongoMapper::Document

      key :title, String
      key :body, String

      timestamps!
    end

## Step five test mongodb

We are going to use irb to test MongoDb and our new Post model.

    irb -r rubygems -r './app.rb'
    > Post.all
    #> []

    > p = Post.new(:title => 'My Awesome title', :body => 'My Awesome
    > Article')
    > p.save
    > Post.all

    > Post.delete_all

    > exit

## Step six setting up Mustache

Mustache come with a built in handler for Sinatra, so it is pretty easy
to setup.

    # Just after the class App < Sinatra::Base line add the following:

    register Mustache::Sinatra
    require 'views/layout'

    set :mustache, { :views => 'views/', :templates => 'templates/' }

    # next change the sinatra get method to the following:

    get '/' do
      mustache :index
    end

    # save and exit app.rb

Now we need to build our Mustache Views and Templates

    mkdir templates
    mkdir views

    touch views/layout.rb
    touch views/index.rb

    touch templates/layout.mustache
    touch templates/index.mustache

Mustache requires a ruby object to manage view code and a mustache
template to specify how the content will be rendered.

Lets setup the view objects first

    cd views
    vim layout.rb

    # Add the following:

    class App
      module Views
        class Layout < Mustache
          def title
            "Mongolog a Blog!"
          end
        end
      end
    end

Next lets create the index.rb file

    vim index.rb

    # add the following:
    class App
      module Views
        class Index < Layout
        end
      end
    end

Now lets build the mustache templates

    # coming from the views directory
    cd .. 
    cd templates
    vim layout.mustache

    <!DOCTYPE html>
    <html>
      <head>
        <title>{{title}}</title>
      </head>
      <body>
        {{{yield}}}
      </body>
    </html>


And finally lets build the index mustache template

    vim index.mustache
    <header>
      <h1>{{title}}</h1>
    </header>
    {{#posts}}
    <article>
      <header>
        <h2>{{title}}</h2>
      </header>
      {{{body}}}
    </article>
    {{/posts}}


# Step six Testing out our Mustache Templates

Leave the templates directory and open app.rb

    cd ..
    vim app.rb

    # change the get '/' block to the following:

    get '/' do
      Post.create(:title => 'Trust the Stache', :body => '<p>Mustache is a
great template language for the client and server</p>')
      @post = Post.all
      mustache :index
    end

Ok, lets save and fire up the browser and see how we do.

    rackup

Navigate to localhost:9292 in your browser and you should see our first
post!

YEA!

# Step Seven implementing the CRUD

This is a long step and we are going to hit a lot of files, so you may
want to go get a refill on your favorite beverage before starting this
section.

### Add CRUD to App.rb

    vim app.rb

    get '/' do
      @posts = Post.all
      mustache :index
    end

    get '/new' do
      @post = Post.new
      mustache :new
    end

    post '/' do
      @post = Post.new(params[:post])
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

Next we need to create templates for show, new, and edit


