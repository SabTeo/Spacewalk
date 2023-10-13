# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


#mock user
user_example = [
    {:username => 'Utente normale', :email => 'user@mail.com',  :password => 'validpass',
        :password_confirmation => 'validpass'},
    {:username => 'utente Admin', :email => 'admin@mail.com',  :password => 'password',
        :password_confirmation => 'password'}
    ]

user_example.each do |user|
    User.create(user)
end

Role.create(name: 'user')
Role.create(name: 'admin')

@user = User.find(1)
@admin = User.find(2)
@admin.remove_role :user
@admin.add_role :admin
local_articles = [{:title => "Apertura Sito", 
            :img_url => 'https://pleated-jeans.com/wp-content/uploads/2020/07/wait-the-always-has-been-meme-is-still-funny-always-has-been-46-memes-6.jpg',
            :body => "Benvenuti su Spacewalk.",
            :local => true,
            :author_id => @user.id,
            :published_at => DateTime.new(2023,9,29,12,24,0),
            :created_at => DateTime.new(2023,9,29,12,24,0),
            :updated_at =>DateTime.new(2023,9,29,12,24,0)},
            {:title => "Yeet", 
            :img_url => 'https://m.media-amazon.com/images/I/51WaOZKYbbL.__AC_SX300_SY300_QL70_FMwebp_.jpg',
            :body => "Yeet",
            :local => true,
            :author_id => @admin.id,
            :published_at => DateTime.new(2023,9,29,12,24,0),
            :created_at => DateTime.new(2023,9,29,12,24,0),
            :updated_at =>DateTime.new(2023,9,29,12,24,0)}
        ]

local_articles.each do |art|
    Article.create(art)
    #perche non funziona @user.proposals.create ?
end

local_proposals = [{
    :title  => "El gato spaziale",
    :img_url => "https://a.pinatafarm.com/960x640/00a5009d4e/james-webb-space-telescope.jpeg",
    :body => "El gato spaziale y vola y canta",
    :status => 0,
    :message => nil,
    :submittes_at => DateTime.new(2023,9,29,12,24,0),
    :user_id => @user,
    :created_at => DateTime.new(2023,9,29,12,24,0),
    :updated_at =>DateTime.new(2023,9,29,12,24,0)},
    {
    :title  => "Roberto ro berto",
    :img_url => "data:image/jpeg;base64,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",
    :body => "El gato spaziale y vola y canta",
    :status => 0,
    :message => nil,
    :submittes_at => DateTime.new(2023,9,29,12,24,0),
    :user_id => @user,
    :created_at => DateTime.new(2023,9,29,12,24,0),
    :updated_at =>DateTime.new(2023,9,29,12,24,0)}]

    ]

local_proposals.each do |pro|
    @user.proposals.create(pro)
end