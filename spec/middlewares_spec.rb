# frozen_string_literal: true

RSpec.describe Middlewares do
  include Rack::Test::Methods

  def app
    Rack::Builder.parse_file('config.ru').first
  end

  context 'when no game init' do
    it 'returns status not found' do
      get '/unknown'
      expect(last_response).to be_not_found
    end

    it 'returns status ok on /' do
      get '/'
      expect(last_response).to be_ok
    end

    it 'returns status ok on /rules' do
      get '/rules'
      expect(last_response).to be_ok
    end

    it 'returns status ok on /statistics' do
      get '/statistics'
      expect(last_response).to be_ok
    end

    it 'redirects from game page' do
      get '/game'
      expect(last_response).to be_redirect
      expect(last_response.header['Location']).to eq('/')
    end
  end
end
