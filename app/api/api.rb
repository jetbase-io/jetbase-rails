class API < Grape::API
  version 'v1', using: :path
  format :json
  prefix :api

  rescue_from JWT::ExpiredSignature do
    error!({ errors: ["Token expired"] }, 401)
  end

  rescue_from JWT::DecodeError do
    error!({ errors: ["Invalid token"] }, 401)
  end

  helpers do
    def authenticate!
      error!({ errors: 'Unauthorized. Invalid or expired token.' }, 401) unless current_user
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

  mount Auth
  mount Users
end
