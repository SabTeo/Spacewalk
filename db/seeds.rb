# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#mock user


User.new({email: 'user@mail.com',username: 'Utente 1', password: 'password', password_confirmation: 'password'}).save(validate:false)
User.new({email: 'admin1@mail.com',username: 'Admin 1' , password: 'password', password_confirmation: 'password'}).save(validate:false)
User.new({email: 'admin2@mail.com',username: 'Admin 2' , password: 'password', password_confirmation: 'password'}).save(validate:false)
Role.create(name: 'user')
Role.create(name: 'admin')
@user = User.find(1)
@admin1 = User.find(2)
@admin2 = User.find(3)

@admin1.remove_role('user')
@admin1.add_role('admin')

@admin2.remove_role('user')
@admin2.add_role('admin')

local_articles = [{:title => "Apertura Sito", 
            :img_url => 'https://pleated-jeans.com/wp-content/uploads/2020/07/wait-the-always-has-been-meme-is-still-funny-always-has-been-46-memes-6.jpg',
            :body => "Benvenuti su Spacewalk.",
            :author_id => @admin1.id,
            :published_at => DateTime.new(2023,9,29,12,24,0),
            :created_at => DateTime.new(2023,9,29,12,24,0),
            :updated_at =>DateTime.new(2023,9,29,12,24,0)},
            {:title => "Yeet", 
            :img_url => 'https://m.media-amazon.com/images/I/51WaOZKYbbL.__AC_SX300_SY300_QL70_FMwebp_.jpg',
            :body => "Yeet",
            :author_id => @admin1.id,
            :published_at => DateTime.new(2023,9,29,12,24,0),
            :created_at => DateTime.new(2023,9,29,12,24,0),
            :updated_at =>DateTime.new(2023,9,29,12,24,0)},
            {:title => "Yeet2", 
            :img_url => 'https://m.media-amazon.com/images/I/51WaOZKYbbL.__AC_SX300_SY300_QL70_FMwebp_.jpg',
            :body => "Yeet2",
            :author_id => @admin1.id,
            :published_at => DateTime.new(2023,9,29,12,24,0),
            :created_at => DateTime.new(2023,9,29,12,24,0),
            :updated_at =>DateTime.new(2023,9,29,12,24,0)}
        ]

local_articles.each do |art|
    Article.create(art)
end

