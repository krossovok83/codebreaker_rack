# frozen_string_literal: true

module Middlewares
  class Welcome
    def self.call(env)
      new(env).response(env).finish
    end

    def initialize(env)
      @request = Rack::Request.new(env)
    end

    def response(env)
      case @request.path
      when Rack::Response.new('Not Found', 404)
      when '/outgoing' then outgoing(env)
      # when '/statistics' then Rack::Response.new(render('statistics.html.haml')).finish
      # when '/rules' then Rack::Response.new(render('rules.html.haml')).finish
      # when '/game'
      else Rack::Response.new('Not Found', 404)
      end
    end

    def outgoing(env)
      Game.call(env)
    end

    private

    def render(template)
      path = File.expand_path("../../app/views/#{template}", __FILE__)
      Haml::Engine.new(File.read(path)).render(binding)
    end
  end
end
