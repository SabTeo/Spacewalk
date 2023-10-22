require 'rails_helper'

RSpec.describe Article, type: :model do
  fixtures :articles

  it 'has title' do
    art = Article.new(title: '', body: 'body')
    expect(art).to_not be_valid
  end

  it 'has body if local' do
    art = Article.new(title: 'Title', body: '', ext_id: nil)
    expect(art).to_not be_valid
  end

  it 'can have no body if external' do
    art = Article.new(title: 'Title', ext_id: 1)
    expect(art).to be_valid
  end

  it 'has a unique title' do
    art = Article.new(title: 'Apertura Sito', body: 'Benvenuti su Spacewalk')
    expect(art).to_not be_valid
  end

end
    