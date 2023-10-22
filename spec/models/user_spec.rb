require 'rails_helper'

RSpec.describe User, type: :model do
  fixtures :users

  it "has a username" do
    user = User.new({email: 'user@mail.com',
                    username: '',
                    password: 'Password1!',
                    password_confirmation: 'Password1!'})
    expect(user).to_not be_valid
    #per utenti sso è garantito da Google
  end

  it "has an email address" do
    user = User.new({email: '',
                    username: 'username',
                    password: 'Password1!',
                    password_confirmation: 'Password1!'})
    expect(user).to_not be_valid
    #per utenti sso è garantito da Google
  end

  it "has an email address that is valid" do 
    user = User.new({email: '@',
                    username: 'username',
                    password: 'Password1!',
                    password_confirmation: 'Password1!'})
    expect(user).to_not be_valid
        user = User.new({email: 'ok.it',
                    username: 'username',
                    password: 'Password1!',
                    password_confirmation: 'Password1!'})
    expect(user).to_not be_valid
    user = User.new({email: 'email@prova.it',
                    username: 'username',
                    password: 'Password1!',
                    password_confirmation: 'Password1!'})
    expect(user).to be_valid
    #per utenti sso è garantito da Google
  end

  it "can have a profile picture no larger than 2MB" do
    user = User.new({email: 'email@prova.it',
                    username: 'username',
                    password: 'Password1!',
                    password_confirmation: 'Password1!'})
    user.image.attach(io:File.open(Rails.root.join('app','assets','images','astronave.jpeg')),
                    filename:'astronave.jpeg',
                    content_type:'image/jpeg')
    expect(user).to be_valid
    user = User.new({email: 'email@prova.it',
                    username: 'username',
                    password: 'Password1!',
                    password_confirmation: 'Password1!'})
    user.image.attach(io:File.open(Rails.root.join('app','assets','images','large_test_image.jpg')),
                    filename:'astronave.jpeg',
                    content_type:'image/jpeg')
    expect(user).to_not be_valid
  end

  it "can not have a profile picture that is not an image" do
    user = User.new({email: 'email@prova.it',
                    username: 'username',
                    password: 'Password1!',
                    password_confirmation: 'Password1!'})
    user.image.attach(io:File.open(Rails.root.join('app','assets','images','not_an_image.c')),
                    filename:'astronave.jpeg',
                    content_type:'image/jpeg')
    expect(user).to be_valid
  end

  context "if not signed in with an external provider" do

    it "has a unique username" do 
      user = User.new({email: 'user@mail.com',
                      username: 'user',
                      password: 'Password1!',
                      password_confirmation: 'Password1!'})
      expect(user).to_not be_valid
    end

    it "has a username with a length between 4 and 15" do
      user = User.new({email: 'user@mail.com',
                      username: 'usr',
                      password: 'Password1!',
                      password_confirmation: 'Password1!'})
      expect(user).to_not be_valid
      user = User.new({email: 'user@mail.com',
                      username: 'user_name_estremamente_lungo',
                      password: 'Password1!',
                      password_confirmation: 'Password1!'})
      expect(user).to_not be_valid
      user = User.new({email: 'user@mail.com',
                      username: 'username',
                      password: 'Password1!',
                      password_confirmation: 'Password1!'})
      expect(user).to be_valid
    end

    it "has a unique email address" do
      user = User.new({email: 'email2@email.com',
                      username: 'username',
                      password: 'Password1!',
                      password_confirmation: 'Password1!'})
      expect(user).to_not be_valid
    end

  end

  context "if signed in with an external provider" do

    it "gets a unique username if signing up with an already existing username" do
      #stub
      auth = double('OmniAuth::AuthHash')
      allow(auth).to receive(:provider) {'google'}
      allow(auth).to receive(:uid) {'uid'}
      allow(auth).to receive_message_chain(:info, :email) {'matteo@prova.it'}
      allow(auth).to receive_message_chain(:info, :name) {'Matteo'}
      #
      user = User.from_omniauth(auth)
      expect(user.username).to match(/Matteo\d\d\d\d/)
      #puts(user.username)
  
    end
  
    it "has a unique email address" do
      #stub
      auth = double('OmniAuth::AuthHash')
      allow(auth).to receive(:provider) {'google'}
      allow(auth).to receive(:uid) {'uid'}
      allow(auth).to receive_message_chain(:info, :email) {'matteo@prova.it'}
      allow(auth).to receive_message_chain(:info, :name) {'Matteo'}
      #
      user = User.from_omniauth(auth)
      expect(user).to_not be_valid
    end
  

  end


end
