# frozen_string_literal: true

require_relative 'autoload'

use Rack::Reloader
use Rack::Static, :urls => %w[/assets/css /assets/images /assets/js /assets]
use Rack::Session::Cookie, :key => 'rack.session',
    :path => '/',
    :expire_after => 2592000

run Middlewares::Game
