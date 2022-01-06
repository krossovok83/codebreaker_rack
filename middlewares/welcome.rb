module Middlewares
  class Game
    def self.call(env)
      new(env).response.finish
    end

    def initialize(env)
      @request = Rack::Request.new(env)
    end

    def response
      case @request.path
      when '/' then home
      when '/game' then game
      when '/statistics' then Rack::Response.new(render('statistics.html.haml'))
      when '/rules' then Rack::Response.new(render('rules.html.haml'))
      when '/create_game' then create_game
      else Rack::Response.new('Not Found', 404)
      end
    end

    def redirect(address = '')
      Rack::Response.new { |response| response.redirect("/#{address}") }
    end

    def render(template)
      path = File.expand_path("../../app/views/#{template}", __FILE__)
      Haml::Engine.new(File.read(path)).render(binding)
    end

    def home
      @request.session.key?('name') ? redirect('game') : Rack::Response.new(render('home.html.haml'))
    end

    def game
      @request.session.key?('game') ? Rack::Response.new(render('game.html.haml')) : redirect
    end

    def create_game
      attempts, hints = difficulty(@request.params['level'])
      @request.session[:game] = CodeBreaker.new(attempts, hints)
      @request.session[:name] = @request.params['player_name'].capitalize
      @request.session[:level] = @request.params['level']
      @request.session[:attempts] = attempts
      @request.session[:hints] = hints
      redirect('game')
    end

    def difficulty(level)
      case level
      when 'simple' then [15, 2]
      when 'middle' then [10, 1]
      else [5, 0]
      end
    end
  end
end