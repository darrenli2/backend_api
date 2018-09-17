require "rails_helper"

RSpec.describe Api::V1::AuthController, type: :controller do
  describe "GET #index" do
    before :each do
      @user = User.create(email: 'a@a.com', password: 'password', password_confirmation: 'password')
    end

    it "returns errors if jwt token is not in request header" do
      get :index
      expect(response.status).to eq 401
      expect(response.body).to include I18n.t('not_authenticated')
    end

    it "returns errors if jwt is in request header but jwt code is invalid" do
      headers = { Authorization:'jwttoken'}
      request.headers.merge! headers
      allow(JsonWebToken).to receive(:decode).and_raise(JWT::DecodeError)
      get :index
      expect(response.status).to eq 401
      expect(response.body).to include I18n.t('not_authenticated')
    end

    it "returns errors if jwt is in request header but jwt code is expired" do
      headers = { Authorization:'jwttoken'}
      request.headers.merge! headers
      allow(JsonWebToken).to receive(:decode).and_raise(JWT::ExpiredSignature)
      get :index
      expect(response.status).to eq 401
      expect(response.body).to include I18n.t('not_authenticated')
    end

    it "returns authenticated and email of the user if jwt is valid" do
      headers = { Authorization:'jwttoken'}
      request.headers.merge! headers
      allow(JsonWebToken).to receive(:decode).and_return({'user_id' => @user.id})
      get :index
      data = JSON.parse(response.body)
      expect(data['authenticated']).to eq true
      expect(data['email']).to eq @user.email
    end
  end

  describe "POST #create" do
    before :each do
      @user = User.create(email: 'a@a.com', password: 'password', password_confirmation: 'password')
    end

    it "returns errors if email is invalid" do
      post :create, {email: '', password: 'password'}
      expect(response.status).to eq 422
      expect(response.body).to include I18n.t('invalid_email_or_password')
    end

    it "returns errors if password is invalid" do
      post :create, {email: 'a@a.com', password: 'ss'}
      expect(response.status).to eq 422
      expect(response.body).to include I18n.t('invalid_email_or_password')
    end

    it "returns an auth_token if email and password are valid" do
      post :create, {email: 'a@a.com', password: 'password'}
      data = JSON.parse(response.body)
      expect(response.body).to include 'auth_token'
    end
  end
end
