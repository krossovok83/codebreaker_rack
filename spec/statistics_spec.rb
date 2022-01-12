# frozen_string_literal: true

RSpec.describe Statistics do
  it 'get statistics' do
    expect(described_class.new.call).to be_a(Array)
  end
end
