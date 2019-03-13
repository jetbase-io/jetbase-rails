class UsersController < ApplicationController
  before_action :authenticate!
  before_action :find_user, only: [:show, :update, :update_password, :destroy]

  def index
    users = User.all
    render json: { data: users }
  end

  def show
    render json: { data: @user }
  end

  def current
    render json: { data: current_user }
  end

  def create
    authorize! :create, User

    user = User.new user_params

    if user.save
      render json: { data: user }
    else
      error! errors: user.errors
    end
  end

  def update
    authorize! :update, @user

    if @user.update(user_params)
      render json: { data: @user }
    else
      error! errors: @user.errors
    end
  end

  def update_password
    authorize! :update, @user

    return error!({ messages: ['Please, enter correct current password'] }, 403) unless @user.authenticate(old_password)

    if @user.update(password_params)
      head 200
    else
      error! errors: @user.errors
    end
  end

  def destroy
    authorize! :delete, @user

    @user.destroy
  end

  private

  def find_user
    @user = User.find params[:id]
  end

  def user_params
    params.permit(:email, :first_name, :last_name, :password)
  end

  def password_params
    params.permit(:password)
  end

  def old_password
    params[:old_password]
  end
end
