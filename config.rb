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
