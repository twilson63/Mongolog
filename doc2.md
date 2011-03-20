# Mongolog Take 2

Now that we have a working blog, we want to do the following:

* Add Stylesheets to make it look pretty
* Add Modernizer to make it work with older browsers

## Lets add some style

First we are going to add compass and sass to the project.

Compass and Sass make the css3 styling very easy, also Compass takes the pain out of adding a grid system to your css.  We are going to use Susy a grid system from the creators of compass.

### Step one add your gems

    echo "gem 'sass', '3.1.0.alpha.249'" >> Gemfile
    echo "gem 'compass', '0.11.beta.3'" >> Gemfile
    echo "gem 'compass-susy-plugin', '0.9.beta.3'" >> Gemfile
    echo "gem 'fancy-buttons', '1.1.0.alpha.1'" >> Gemfile

    bundle install
    
Now that we have the latest gems installed, lets tell sinatra about compass.

    vim app.rb
    
    require 'sass'
    require 'compass'

Then inside class App < Sinatra::Base add:

    configure do
      config_file = File.join(Sinatra::Application.root, 'config.rb')
      Compass.add_project_configuration(config_file)
    end
    
    get '/stylesheets/:name.css' do
      content_type 'text/css', :charset => 'utf-8'
      sass(:"stylesheets/#{params[:name]}", Compass.sass_engine_options )
    end
    
    
Now we need to create a config.rb file:

    touch config.rb
    
    vim config.rb
    
    require 'susy'
    require 'fancy-buttons'

    if defined?(Sinatra)
      # This is the configuration to use when running within sinatra
      project_path = Sinatra::Application.root
      css_dir = File.join 'public', 'stylesheets'
      environment = :development

    else
      # this is the configuration to use when running within the compass command line tool.
      css_dir = File.join 'public', 'stylesheets'
      relative_assets = true
      environment = :production
    end


    # Get the directory that this configuration file exists in
    #dir = File.dirname(__FILE__)

    # Load the sencha-touch framework automatically.
    #load File.join(dir, '..', 'resources', 'themes')

    # Require any additional compass plugins here.
    # Set this to the root of your project when deployed:
    http_path = "/"
    sass_dir = File.join 'views', 'stylesheets'
    images_dir = File.join 'public', 'images'
    javascripts_dir = File.join 'public', 'javascripts'
    http_images_path = "/images"
    http_stylesheets_path = "/stylesheets"    
    
    # Save
    
    Then run the following:
    
    compass create . -r susy -u susy
    
    compass install -r fancy-buttons -f fancy-buttons
    
Now we need to add the screen css and the ie6 css to our layout template

    vim templates/layout.mustache
    
    # in the head section add these lines below the title:
    <link href="/stylesheets/screen.css" media="screen, projection" rel="stylesheet" type="text/css" />
    <!--[if lt IE 7]>
      <link href="/stylesheets/ie6.css" media="screen, projection" rel="stylesheet" type="text/css" />
    <![endif]-->

# Mongolog Take 3

* Add Authentication
* Add Authorization
* Add Markdown