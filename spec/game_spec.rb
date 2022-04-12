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
END_GAME = {
  win: '/win',
  lose: '/lose'
}.freeze
FILE = 'test.yml'

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

    it 'redirect from win/lose' do
      END_GAME.each_value do |address|
        get address
        expect(last_response).to be_redirect
        expect(last_response.header['Location']).to eq('/')
      end
    end
  end

  context 'when game init' do
    before do
      get GAME_GROUP[:create], 'player_name' => 'Test', 'level' => 'simple'
    end

    it 'redirect to game page' do
      NO_GAME_GROUP.each_value do |address|
        get address
        expect(last_response).to be_redirect
        expect(last_response.header['Location']).to eq('/game')
      end
    end

    it 'redirect from win/lose' do
      END_GAME.each_value do |address|
        get address
        expect(last_response).to be_redirect
        expect(last_response.header['Location']).to eq('/')
      end
    end
  end

  context 'when lose' do
    before do
      get GAME_GROUP[:create], 'player_name' => 'Test', 'level' => 'hard'
    end

    it '5 times wrong answer' do
      5.times do
        get "#{GAME_GROUP[:submit]}?number=1111"
      end
      expect(last_response).to be_redirect
      expect(last_response.header['Location']).to eq('/lose')
    end
  end

  context 'when win' do
    let(:yaml) { YAML.safe_load(File.read(FILE)) }

    before do
      File.open(FILE, 'a')
      get GAME_GROUP[:create], 'player_name' => 'Test', 'level' => 'middle'
    end

    after do
      File.delete(FILE) if File.exist?(FILE)
    end

    it 'correct answer' do
      allow(File).to receive(:open).and_return(yaml)
      get "#{GAME_GROUP[:submit]}?number=#{last_request.env['rack.session']['game'].code.join}"
      expect(last_response).to be_redirect
      expect(last_response.header['Location']).to eq('/win')
    end
  end

  context 'when hint' do
    before do
      get GAME_GROUP[:create], 'player_name' => 'Test', 'level' => 'simple'
    end

    it 'get hint' do
      get GAME_GROUP[:hint]
      expect(last_response).to be_redirect
      expect(last_response.header['Location']).to eq('/game')
      expect(last_request.env['rack.session']['game'].hints).to eq(1)
    end
  end
end
