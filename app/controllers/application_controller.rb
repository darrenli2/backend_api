class ApplicationController < ActionController::API
  include ActionController::Serialization

  attr_reader :current_user

  protected
  # To check user's auth token
  def authenticate_user
    begin
      @current_user = User.find(auth_token['user_id'])
    rescue Exception => e
      render json: { errors: I18n.t('not_authenticated') }, status: :unauthorized
    end
  end

  private

  def http_token
    @http_token ||= request.headers['Authorization'].split(' ').last
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end
end
