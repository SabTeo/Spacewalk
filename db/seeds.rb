# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
local_articles = [{:ext_id => nil,:title => "Apertura Sito", 
            :img_url => 'https://pleated-jeans.com/wp-content/uploads/2020/07/wait-the-always-has-been-meme-is-still-funny-always-has-been-46-memes-6.jpg',
            :body => "Benvenuti su Spacewalk.",
            :local => true,
            :author_id => nil,
            :url => nil,
            :news_site => nil,
            :published_at => DateTime.new(2023,9,29,12,24,0)},
        ]

local_articles.each do |art|
    Article.create!(art)
end

#mock user
User.create!({:email => 'fake@mail.com', :encrypted_password => '#$taawtljaskt', :password => 'validpass',
            :password_confirmation => 'validpass'})

Comment.create!({:user => User.find(1), :text => 'Bello!', :published_at => DateTime.new(2023,9,29,12,25,0),
                :article => Article.find_by(title: "Apertura Sito")})