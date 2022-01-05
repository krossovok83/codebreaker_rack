# frozen_string_literal: true

require './middlewares/index'
require 'haml'

use Rack::Reloader
use Rack::Static, :urls => ['/assets/css', '/assets/images', '/assets/js', '/assets']

run Middlewares::Welcome.new
