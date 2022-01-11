# frozen_string_literal: true

NO_GAME_GROUP = {
  home: '/',
  rules: '/rules',
  statistics: '/statistics'
}.freeze
GAME_GROUP = {
  game: '/game',
  create: '/create_game',
  submit: '/submit_answer',
  hint: '/hint',
  play_again: '/play_again'
}.freeze

RSpec.describe Game do
  include Rack::Test::Methods

  def app
    Rack::Builder.parse_file('config.ru').first
  end

  context 'when no game init' do
    it 'returns status not found if /unknown' do
      get '/unknown'
      expect(last_response).to be_not_found
    end

    it 'returns status ok on /' do
      get NO_GAME_GROUP[:home]
      expect(last_response).to be_ok
    end

    it 'returns status ok' do
      NO_GAME_GROUP.each_value do |address|
        get address
        expect(last_response).to be_ok
      end
    end

    it 'redirects from page' do
      GAME_GROUP.each_value do |address|
        get address
        expect(last_response).to be_redirect
        expect(last_response.header['Location']).to eq('/')
      end
    end

    context 'when game init' do
      before do
        get '/create_game', 'player_name' => 'Test', 'level' => 'simple'
      end

      it 'redirect to game page' do
        NO_GAME_GROUP.each_value do |address|
          get address
          expect(last_response).to be_redirect
          expect(last_response.header['Location']).to eq('/game')
        end
      end
    end
  end
end
