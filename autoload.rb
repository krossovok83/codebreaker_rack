# frozen_string_literal: true

require 'bundler/setup'
require 'code_breaker'
require './lib/middlewares/router'
require 'haml'
require 'pry'
require 'simplecov'

autoload :Rack, 'rubygems'
autoload :CodeBreaker, 'rubygems'
autoload :Middlewares, './middlewares/game'
autoload :Game, './lib/game'
autoload :Statistics, './lib/statistics'
