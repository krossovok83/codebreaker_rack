# frozen_string_literal: true

require_relative 'autoload'

use Rack::Reloader
use Rack::Static, :urls => %w[/assets/css /assets/images /assets/js /assets /app/views]
use Rack::Session::Cookie, :key => 'rack.session',
    :path => '/',
    :expire_after => 2592000,
    :secret => 'very_big_secret'

# run Middlewares::Game
# run Rack::Cascade.new([Rack::File.new('app/views'), Middlewares::Game])
app = Rack::Builder.new do
  use Middlewares::Router
  run Game
end

run app