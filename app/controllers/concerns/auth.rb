# frozen_string_literal: true

module Auth
  def authenticate!
    error!({ messages: ['Unauthorized. Invalid or expired token.'] }, 401) if token_exist? || !current_user
  end

  def current_user
    @current_user ||= User.find decoded_user_id
  end

  def token_exist?
    JwtBlacklist.exists?(token: http_auth_header_token)
  end

  def decoded_user_id
    JwtAuth.decode(http_auth_header_token)['user_id']
  end

  def http_auth_header_token
    request.headers['Authorization']&.split(' ')&.last
  end
end
