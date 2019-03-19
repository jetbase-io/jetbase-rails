# frozen_string_literal: true

require 'jwt'

class JwtAuth
  ALGORITHM = 'HS256'

  def self.issue(payload)
    JWT.encode(payload,
               auth_secret,
               ALGORITHM)
  end

  def self.decode(token)
    JWT.decode(token,
               auth_secret,
               true,
               algorithm: ALGORITHM).first
  end

  def self.auth_secret
    Jetbase::Application.credentials.secret_key_base || 'secret_key'
  end
end
