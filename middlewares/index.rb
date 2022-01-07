# frozen_string_literal: true

module Middlewares
  class Welcome
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      case request.path
      when '/' then Rack::Response.new(render('home.html.haml')).finish
      when '/statistics' then Rack::Response.new(render('statistics.html.haml')).finish
      when '/rules' then Rack::Response.new(render('rules.html.haml')).finish
      when '/game'

        @app.call(env)
      else Rack::Response.new('Not Found', 404).finish
      end
    end

    private

    def render(template)
      path = File.expand_path("../../app/views/#{template}", __FILE__)
      Haml::Engine.new(File.read(path)).render(binding)
    end
  end
end
