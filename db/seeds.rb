# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Role.create(name: 'user')
Role.create(name: 'admin')

user_example = [
    {:username => 'utente normale', :email => 'user@mail.com',  :password => 'validpass',
        :password_confirmation => 'validpass'},
    {:username => 'utente admin', :email => 'admin@mail.com',  :password => 'password',
        :password_confirmation => 'password'}
    ]

user_example.each do |user|
    u = User.new(user)
    u.test_user = true
    u.save(validate: false)
end

#User.new({email: 'user@mail.com',username: 'Utente 1', password: 'password', password_confirmation: 'password'}).save(validate:false)
#User.new({email: 'admin1@mail.com',username: 'Admin 1' , password: 'password', password_confirmation: 'password'}).save(validate:false)
#User.new({email: 'admin2@mail.com',username: 'Admin 2' , password: 'password', password_confirmation: 'password'}).save(validate:false)

user = User.find_by(username: 'utente normale').add_role('user')
admin = User.find_by(username: 'utente admin').add_role('admin')

local_articles = [{:title => "Apertura Sito", 
            :img_url => 'https://pleated-jeans.com/wp-content/uploads/2020/07/wait-the-always-has-been-meme-is-still-funny-always-has-been-46-memes-6.jpg',
            :body => "Benvenuti su Spacewalk.",
            :author_id => user,
            :published_at => DateTime.new(2023,9,29,12,24,0)},
            {:title => "Yeet", 
            :img_url => 'https://m.media-amazon.com/images/I/51WaOZKYbbL.__AC_SX300_SY300_QL70_FMwebp_.jpg',
            :ext_id => 1,
            :url => 'https://www.ansa.it/',
            :published_at => DateTime.new(2023,9,29,12,24,0)}
        ]

local_articles.each do |art|
    Article.create(art)
end
