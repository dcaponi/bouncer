module JsonWebToken
  extend ActiveSupport::Concern
  SECRET_KEY = ENV['SIGNING_SECRET']

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    begin
      decoded = JWT.decode(token, SECRET_KEY)[0]
      HashWithIndifferentAccess.new decoded
    rescue
      {error: "not signed in"}
    end
  end

end
