# frozen_string_literal: true

require 'bundler/setup'
require 'code_breaker'
require './middlewares/index'
require './middlewares/game'
require 'haml'
require 'pry'
require 'simplecov'

autoload :Rack, 'rubygems'
autoload :CodeBreaker, 'rubygems'
autoload :Middlewares, './middlewares/game'
