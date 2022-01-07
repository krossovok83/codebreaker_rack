# frozen_string_literal: true

module Middlewares
  class Game
    def self.call(env)
      new(env).response.finish
    end

    def initialize(env)
      @request = Rack::Request.new(env)
    end

    # rubocop:disable Metrics
    def response
      case @request.path
      when '/' then home
      when '/game' then game
      when '/statistics' then Rack::Response.new(render('statistics.html.haml'))
      when '/rules' then Rack::Response.new(render('rules.html.haml'))
      when '/create_game' then create_game
      when '/submit_answer' then submit_answer
      when '/play_again' then play_again
      when '/hint' then hint
      else Rack::Response.new('Not Found', 404)
      end
    end
    # rubocop:enable Metrics

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
      return win if @request.session[:win] == 'true'

      return lose if @request.session[:win] == 'false'

      if @request.session.key?('game') && @request.session['game'].attempts_left.positive?
        Rack::Response.new(render('game.html.haml'))
      else
        redirect
      end
    end

    def create_game
      attempts, hints = difficulty(@request.params['level'])
      @request.session[:game] = CodeBreaker.new(attempts, hints)
      @request.session[:name] = @request.params['player_name'].capitalize
      @request.session[:level] = @request.params['level']
      @request.session[:attempts] = attempts
      @request.session[:hints] = hints
      @request.session[:answer] = %w[x x x x]
      @request.session[:hint] = Array.new(hints) { 'x' }
      redirect('game')
    end

    def difficulty(level)
      case level
      when 'simple' then [15, 2]
      when 'middle' then [10, 1]
      else [5, 0]
      end
    end

    def submit_answer
      @request.session['game'].compare(@request.params['number'])
      while @request.session['game'].instance_variable_get('@response').size != 4
        @request.session['game'].instance_variable_get('@response') << 'x'
      end
      @request.session[:answer] = @request.session['game'].instance_variable_get('@response')
      win || lose || redirect('game')
    end

    def win
      return unless @request.session['game'].instance_variable_get('@response') == %w[+ + + +]

      @request.session[:win] = 'true'
      save_game
      Rack::Response.new(render('win.html.haml'))
    end

    def lose
      return if @request.session['game'].attempts_left.positive?

      @request.session[:win] = 'false'
      Rack::Response.new(render('lose.html.haml'))
    end

    def play_again
      @request.session.clear
      redirect
    end

    def hint
      return redirect('game') if @request.session[:game].hints.zero?

      one_hint = @request.session[:game].hint
      @request.session[:hint][@request.session[:hint].index('x')] = one_hint
      redirect('game')
    end

    def save_game
      return if @request.session['saved'] == 'true'

      @request.session['saved'] = 'true'
      @request.session['game'].save(@request.session['name'], @request.session['level'])
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
