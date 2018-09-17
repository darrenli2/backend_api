require "rails_helper"

RSpec.describe Api::V1::UsersController, type: :controller do
  describe "POST #create" do
    let(:params) { {user: {email: 'a@a.com', password: 'password', password_confirmation: 'password'}} }

    it "returns errors if recaptcha verification fails" do
      allow(RestClient).to receive(:post).and_return({"success": false}.to_json)
      post :create, params
      expect(response.status).to eq 422
      expect(response.body).to include I18n.t('verification_failed')
    end

    it "returns user model if recaptcha verification is successful" do
      allow(RestClient).to receive(:post).and_return({"success": true}.to_json)
      post :create, params
      expect(response.status).to eq 200
      expect(response.body).to include 'a@a.com'
    end
  end
end
