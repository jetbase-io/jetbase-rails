class ApplicationController < ActionController::API
  rescue_from JWT::ExpiredSignature do
    error!({ messages: ["Token expired"] }, 401)
  end

  rescue_from JWT::DecodeError do
    error!({ messages: ["Invalid token"] }, 401)
  end

  protected

  def error! data, status = 400
    render json: data, status: status
  end

  def authenticate!
    error!({ messages: ['Unauthorized. Invalid or expired token.'] }, 401) unless current_user
  end

  def http_auth_header_token
    request.headers['Authorization']&.split(' ')&.last
  end

  def decoded_user_id
    JwtAuth.decode(http_auth_header_token)['user_id']
  end

  def current_user
    @current_user ||= User.find decoded_user_id
  end
end
