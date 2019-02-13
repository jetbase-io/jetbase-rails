class Auth < API
  helpers do
    def permitted?
      request.env['ORIGINAL_FULLPATH'] == '/api/v1/login'
    end
  end

  before do
    authenticate! unless permitted?
  end

  desc 'JWT authentification'
  params do
    requires :username
    requires :password
  end
  post :login do
    user = User.find_by(username: params[:username])

    if user.authenticate(params[:password])
      token = user.generate_jwt_token
      present :token, token
    else
      error!({ errors: ['Username or password is invalid'] })
    end
  end

  desc 'Logout'
  delete :logout do
    JwtBlacklist.create user: current_user, token: http_auth_header_token
  end
end
