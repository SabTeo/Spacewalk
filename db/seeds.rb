# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


#mock user
user_example = [
    {:username => 1, :email => 'user@mail.com',  :password => 'validpass',
        :password_confirmation => 'validpass'},
    {:username => 2, :email => 'admin@mail.com',  :password => 'password',
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


local_articles = [{:ext_id => nil,:title => "Apertura Sito", 
            :img_url => 'https://pleated-jeans.com/wp-content/uploads/2020/07/wait-the-always-has-been-meme-is-still-funny-always-has-been-46-memes-6.jpg',
            :body => "Benvenuti su Spacewalk.",
            :local => true,
            :url => nil,
            :news_site => nil,
            :published_at => DateTime.new(2023,9,29,12,24,0)},
            {:ext_id => nil,:title => "Yeet", 
            :img_url => 'https://m.media-amazon.com/images/I/51WaOZKYbbL.__AC_SX300_SY300_QL70_FMwebp_.jpg',
            :body => "Yeet",
            :local => true,
            :url => nil,
            :news_site => nil,
            :published_at => nil}
        ]

local_articles.each do |art|
    @user.articles.create(art)
end

Comment.create({:user => User.find(1), :text => 'Bello!', :published_at => DateTime.new(2023,9,29,12,25,0),
                :article => Article.find_by(title: "Apertura Sito")})


