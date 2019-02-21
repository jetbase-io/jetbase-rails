class AuthController < ApplicationController
  before_action :authenticate!, except: [:login]

  def login
    user = User.find_by(email: params[:email])

    if user.authenticate(params[:password])
      token = user.generate_jwt_token
      render json: { token: token }
    else
      error!({ errors: ['Username or password is invalid'] })
    end
  end

  def logout
    JwtBlacklist.create user: current_user, token: http_auth_header_token
  end
end
