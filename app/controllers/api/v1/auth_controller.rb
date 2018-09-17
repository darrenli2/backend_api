module Api::V1
  # Authentication controller
  class AuthController < ApplicationController
    before_action :authenticate_user, only: [:index]
    # Renders JSON containing an auth_token.
    #
    # POST /v1/auth
    def create
      @user = User.find_by_email(params[:email])
      if @user.try(:valid_password?, params[:password])
        render json: {auth_token: ::JsonWebToken.encode({user_id: @user.id})}
      else
        render json: {error: I18n.t('invalid_email_or_password')} , status: :unprocessable_entity
      end
    end

    # Renders JSON containing user's email and authenticated information.
    #
    # GET /v1/auth
    def index
      render json: {authenticated: true, email: current_user.email }
    end
  end
end
