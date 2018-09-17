module Api::V1
  # Users controller
  class UsersController < ApplicationController
    before_action :verify_recaptcha, only: [:create]
    # Renders JSON containing user information.
    #
    # POST /v1/users
    def create
      @user = User.new(user_params)
      if @user.save
        render json: @user
      else
        render json: @user.errors , status: :unprocessable_entity
      end
    end

    private

    # White list params for user's creation
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

    # To verify google's recaptcha response from client side
    def verify_recaptcha
      response = RestClient.post Settings.google_verify_url, {
                                                                secret: Rails.application.secrets.recaptcha,
                                                                response: params["recaptcha_response"]
                                                              }
      render json: { error: I18n.t('verification_failed') }, status: :unprocessable_entity unless JSON.parse(response)["success"]
    end
  end
end
