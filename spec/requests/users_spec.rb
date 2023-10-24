require 'rails_helper'

RSpec.describe "Users", type: :request do
  fixtures :users
  include Devise::Test::IntegrationHelpers

  describe "GET /users/edit" do
    
    it "redirects if not logged in" do
      get '/users/edit'
      expect(response).to have_http_status(302)
    end

    it "shows profile if logged in" do
      sign_in(User.first)
      get '/users/edit'
      expect(response).to have_http_status(200)
    end

  end

  describe "POST /users" do #devise controller

    it "Creates new user with default image if params are valid" do
      post '/users', :params => {"user"=>{"email"=>"nuovamail@ok.it", "username"=>"newUser", "password"=>"Passw0rd!", "password_confirmation"=>"Passw0rd!"}, "commit"=>"Sign up"}
      expect(response).to have_http_status(303)
      expect(User.find_by(email: "nuovamail@ok.it")).not_to be_nil
      expect(User.find_by(email: "nuovamail@ok.it").image.filename).to eq('astronave.jpeg')
    end

    it "Returns error params are not valid" do
      post '/users', :params => {"user"=>{"email"=>"", "username"=>"newUser", "password"=>"Passw0rd!", "password_confirmation"=>"Passw0rd!"}, "commit"=>"Sign up"}
      expect(response).to have_http_status(422)
      expect(response.body).to include('error')
    end

    it "Returns error if username is taken" do
      post '/users', :params => {"user"=>{"email"=>"nuovamail@ok.it", "username"=>"user", "password"=>"Passw0rd!", "password_confirmation"=>"Passw0rd!"}, "commit"=>"Sign up"}
      expect(response).to have_http_status(422)
      expect(response.body).to include('error')
    end
    
  end

  describe "POST /user/id/edit" do #user_controller

    it "returns 401 and redirects if user not signed in" do
      post '/user/1/edit', :params => {"username"=>"admin", "commit"=>"salva"}
      expect(response).to have_http_status(401)
      expect(response.body).to include('You are being')
    end

    it "returns 401 and redirects if signed in user tries to modify another user" do
      sign_in(User.find(1))
      post '/user/2/edit', :params => {"username"=>"user", "commit"=>"salva"}
      expect(response).to have_http_status(401)
      expect(response.body).to include('You are being')

    end

    it "returns 404 and redirects if signed in user tries to modify non existent user" do
      sign_in(User.find(1))
      post '/user/99/edit', :params => {"username"=>"user", "commit"=>"salva"}
      expect(response).to have_http_status(404)
      expect(response.body).to include('You are being')

    end

    it "does nothing if no field is altered" do
      sign_in(User.find(1))
      post '/user/1/edit', :params => {"username"=>"admin", "commit"=>"salva"}
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).not_to include('successo')
    end

    it "modifies username if the new username is valid and available" do
      sign_in(User.find(1))
      post '/user/1/edit', :params => {"username"=>"admin2", "commit"=>"salva"}
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).to include('successo')
      expect(User.find(1).username).to eq("admin2")
    end

    it "does not modify username if the new username has an invalid lenght" do
      sign_in(User.find(1))
      post '/user/1/edit', :params => {"username"=>"a", "commit"=>"salva"}
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).to include('caratteri')
    end

    it "does not modify username if the new username is taken" do
      sign_in(User.find(1))
      post '/user/1/edit', :params => {"username"=>"user", "commit"=>"salva"}
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).to include('present')
    end

    it "modifies profile pic if the attached picture is valid" do
      sign_in(User.find(1))
      img = Rack::Test::UploadedFile.new(Rails.root.join('spec/support/test_image.jpg'), 'image/jpg') 
      post '/user/1/edit', :params => {"username"=>"admin2", "commit"=>"salva", "image"=>img}
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).to include('successo')
      expect(User.find(1).image.filename).to eq('test_image.jpg')
    end

    it "does not modify profile pic if the attached picture is larger than 2MB" do
      sign_in(User.find(1))
      img = Rack::Test::UploadedFile.new(Rails.root.join('spec/support/large_test_image.jpg'), 'image/jpg') 
      post '/user/1/edit', :params => {"username"=>"admin2", "commit"=>"salva", "image"=>img}
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).to include('grande')
      expect(User.find(1).image.filename).not_to eq('large_test_image.jpg')
    end

    it "does not modify profile pic if the attached file is not in an image" do
      sign_in(User.find(1))
      img = Rack::Test::UploadedFile.new(Rails.root.join('spec/support/not_an_image.c'), 'text') 
      post '/user/1/edit', :params => {"username"=>"admin2", "commit"=>"salva", "image"=>img}
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).to include('formato')
      expect(User.find(1).image.filename).not_to eq('test_image.jpg')
    end

  end

  describe "DELETE /users" do

    it "does not delete users" do
      sign_in(User.find(1))
      delete '/users/'
      expect(response).to have_http_status(302)
      expect(User.exists?(id:1)).to eq(true)
    end

  end

end
