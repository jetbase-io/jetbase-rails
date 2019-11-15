class UsersController < ApplicationController
  before_action :authenticate!
  before_action :find_user, only: %i[show update update_password destroy]

  def index
    users = User.all
    render json: { items: users, count: users.count }
  end

  def show
    render json: @user
  end

  def current
    render json: current_user
  end

  def create
    user = User.new user_params

    if user.save
      render json: user
    else
      error! errors: user.errors
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      error! errors: @user.errors
    end
  end

  def update_password
    return error!({ messages: ['Please, enter correct current password'] }, 403) unless @user.authenticate(old_password)

    if @user.update(password: new_password)
      head 200
    else
      error! errors: @user.errors
    end
  end

  def destroy
    @user.destroy
  end

  private

  def find_user
    @user = User.find params[:id]
  end

  def user_params
    params.permit(:email, :first_name, :last_name, :password)
  end

  def old_password
    params[:old_password]
  end

  def new_password
    params[:new_password]
  end
end
