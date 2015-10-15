require 'rubygems'
require 'bundler'
require 'bundler/setup'

require 'sinatra'
require './is_it_a_haiku_app'

## There is no need to set directories here anymore;
## Just run the application

run IsItAHaikuApp
