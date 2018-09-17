# A helper class for encode and decode jwt token
class JsonWebToken
  def self.encode(payload, expiration = 2.weeks.from_now)
    payload[:exp] = expiration.to_i
    JWT.encode(payload, Rails.application.secrets.json_web_token_secret)
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.secrets.json_web_token_secret).first
  end
end
