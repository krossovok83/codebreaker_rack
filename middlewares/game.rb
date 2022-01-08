# frozen_string_literal: true

module Middlewares
  class Game
    def self.call(env)
      new(env).response.finish
    end

    def initialize(env)
      @request = Rack::Request.new(env)
      @session = @request.session
      @params = @request.params
    end

    # rubocop:disable Metrics
    def response
      case @request.path
      when '/' then home
      when '/game' then game
      when '/statistics' then Rack::Response.new(render('statistics.html.haml'))
      when '/rules' then Rack::Response.new(render('rules.html.haml'))
      when '/create_game' then create_game && redirect('game')
      when '/submit_answer' then submit_answer
      when '/play_again' then @session.clear && redirect
      when '/hint' then hint && redirect('game')
      else Rack::Response.new('Not Found', 404)
      end
    end
    # rubocop:enable Metrics

    def redirect(address = '')
      Rack::Response.new { |response| response.redirect("/#{address}") }
    end

    def render(template)
      Haml::Engine.new(File.read(File.expand_path("../app/views/#{template}", __dir__))).render(binding)
    end

    def home
      @session.key?('name') ? redirect('game') : Rack::Response.new(render('home.html.haml'))
    end

    def game
      return win if @session[:win] == 'true'

      return lose if @session[:win] == 'false'

      if @session.key?('game') && @session['game'].attempts_left.positive?
        Rack::Response.new(render('game.html.haml'))
      else
        redirect
      end
    end

    def create_game
      @session[:name] = @params['player_name'].capitalize
      @session[:level] = @params['level']
      attempts, hints = difficulty(@session['level'])
      @session[:game] = CodeBreaker.new(attempts, hints)
      @session[:attempts] = attempts
      @session[:hints] = hints
      @session[:answer] = %w[x x x x]
      @session[:hint] = Array.new(hints) { 'x' }
    end

    def difficulty(level)
      case level
      when 'simple' then [15, 2]
      when 'middle' then [10, 1]
      else [5, 0]
      end
    end

    def submit_answer
      @session['game'].compare(@params['number'])
      while @session['game'].instance_variable_get('@response').size != 4
        @session['game'].instance_variable_get('@response') << 'x'
      end
      @session[:answer] = @session['game'].instance_variable_get('@response')
      win || lose || redirect('game')
    end

    def win
      return unless @session['game'].instance_variable_get('@response') == %w[+ + + +]

      @session[:win] = 'true'
      save_game
      Rack::Response.new(render('win.html.haml'))
    end

    def lose
      return if @session['game'].attempts_left.positive?

      @session[:win] = 'false'
      Rack::Response.new(render('lose.html.haml'))
    end

    def hint
      return redirect('game') if @session[:game].hints.zero?

      one_hint = @session[:game].hint
      @session[:hint][@session[:hint].index('x')] = one_hint
    end

    def save_game
      return if @session['saved'] == 'true'

      @session['saved'] = 'true'
      @session['game'].save(@session['name'], @session['level'])
    end

    def statistics
      return [[]] if CodeBreaker.stats.nil?

      rows(CodeBreaker.stats.sort_by { |i| [i[1][:attempts], i[1][:attempt_used]] }).each { |i| i.delete_at(4) }
    end

    def rows(hash)
      rows = []
      hash.each do |breaker|
        row = []
        row << (hash.find_index(breaker) + 1)
        row << breaker.first.to_s
        breaker.last.each { |param| row << param.last }
        rows << row
      end
      rows
    end
  end
end
