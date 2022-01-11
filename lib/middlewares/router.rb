# frozen_string_literal: true

module Middlewares
  class Router
    REQUEST_PATHS = %w[/ /game /statistics /rules /create_game /submit_answer /play_again /hint /win /lose].freeze
    def call(env)
      @request = Rack::Request.new(env)
      response(env)
    end

    def initialize(app)
      @app = app
    end

    def response(env)
      if REQUEST_PATHS.include? @request.path
        @app.call(env)
      else
        Rack::Response.new('Not Found', 404)
      end
    end
  end
end
