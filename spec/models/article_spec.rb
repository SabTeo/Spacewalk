require 'rails_helper'

RSpec.describe Article, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"

  it 'has title' do
    art = Article.new(title: '', body: 'body')
    expect(art).to_not be_valid
  end

  it 'has body if local' do
    art = Article.new(title: 'Title', body: '', ext_id: nil)
    expect(art).to_not be_valid
  end

  it 'can have no body if external' do
    art = Article.new(title: 'Title2', ext_id: 1)
    expect(art).to be_valid
  end

  it 'has a unique title' do
    art =Article.create(title: 'Title3',  body: 'body')
    art2 = Article.new(title: 'Title3', body: 'body2')
    expect(art2).to_not be_valid
  end

end
    