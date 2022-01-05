# frozen_string_literal: true

module Middlewares
  class Racker
    def call(env)
      Rack::Response.new(render('home.html.haml')).finish
    end

    private

    def render(template)
      path = File.expand_path("../../app/views/#{template}", __FILE__)
      Haml::Engine.new(File.read(path)).render(binding)
    end
  end
end
