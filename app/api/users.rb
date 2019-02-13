class Users < API
  before do
    authenticate!
  end

  resource :users do
    desc 'Get users'
    get do
      users = User.all
      users
    end

    desc 'Get user by id'
    get ':id' do
      user = User.find params[:id]

    end

    desc 'Get current user'
    get :current do
      current_user
    end

    desc 'Create user'
    post do
      user = User.new user_params

      if user.save

      else

      end
    end

    desc 'Update user'
    put ':id' do
      if user.update(user_params)
      else
      end
    end

    desc 'Update password'
    put ':id/password' do
      if user.update(password_params)
      else
      end
    end

    desc 'Delete user'
    delete ':id' do
      User.find(params[:id]).destroy
    end
  end
end
