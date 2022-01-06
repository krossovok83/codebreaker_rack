# frozen_string_literal: true

require 'bundler/setup'
require 'code_breaker'
require './middlewares/welcome'
require 'haml'
require 'pry'

autoload :Rack, 'rubygems'
autoload :CodeBreaker, 'rubygems'
