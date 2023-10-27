require 'rails_helper'

RSpec.describe "Articles", type: :request do
  fixtures :articles
  fixtures :users
  include Devise::Test::IntegrationHelpers

  describe "GET /articles" do

    it "completes with a valid page index" do
      get '/articles', :params => { page: 1 }
      expect(response).to have_http_status(200)
    end

    it "fails with an invalid page index" do
      get '/articles', :params => { page: 20 }
      expect(response).to have_http_status(404)
    end

  end

  describe "GET /articles/id" do

    describe "for an existing article" do

      it "shows a local article" do
        get '/articles/1'
        expect(response).to have_http_status(200)
        expect(response.body).to  include("Apertura Sito")
      end

      it "shows an external article" do
        get '/articles/2'
        expect(response).to have_http_status(302)
        expect(response).to redirect_to ('https://www.ansa.it/')
      end

    end

    it "returns error for a non existing article" do
      get '/articles/99'
      expect(response).to have_http_status(404)
    end

  end

  describe "POST /articles" do
    
    describe "if logged in as admin" do

      it "create and show article if succesfull" do
        User.find(1).add_role(:admin)
        sign_in User.find(1)
        post '/articles', :params => {:article => { title: 'Articolo', body: '...', published_at: 'Sat, 21 Oct 2023 20:37:28 +0200' }}
        expect(response).to have_http_status(302)
        follow_redirect!
        expect(response.body).to include('successo')
      end

      it "returns error if parameters are invalid" do
        User.find(1).add_role(:admin)
        sign_in User.find(1)
        post '/articles', :params => {:article => { title: 'Articolo', body: '' }}
        expect(response).to have_http_status(422)
        post '/articles', :params => {:article => { title: '   ', body: '...' }}
        expect(response).to have_http_status(422)
        expect(response.body).to include("non validi")
      end

    end

    it "returns error and redirects if user is not authorized" do
      post '/articles', :params => {:article => { title: 'Articolo', body: '...' }}
      expect(response).to have_http_status(401)
      expect(response.body).to include("You are being")
    end
    
  end

  describe "Delete /articles/id" do

    it "succeeds if user is an admin and article exists" do
      User.find(1).add_role(:admin)
      sign_in User.find(1)
      delete '/articles/1'
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).to include('eliminato')
    end

    it "fails if articles does not exist" do
      delete '/articles/99'
      expect(response).to have_http_status(404)
    end

    it "returns error and redirects if user is not authorized" do
      delete '/articles/1'
      expect(response).to have_http_status(401)
      expect(response.body).to include("You are being")
    end

    it "returns error and redirects if article is not local" do
      User.find(1).add_role(:admin)
      sign_in User.find(1)
      delete '/articles/2'
      expect(response).to have_http_status(401)
      expect(response.body).to include("You are being")
    end

  end


end
