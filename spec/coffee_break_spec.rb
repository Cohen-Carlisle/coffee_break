require 'spec_helper'

describe CoffeeBreak do
  it 'has a version number' do
    expect(CoffeeBreak::VERSION).not_to be nil
  end

  it 'can take a coffee break' do
    expect(Coffee::Break).to eq '☕'
  end
end
