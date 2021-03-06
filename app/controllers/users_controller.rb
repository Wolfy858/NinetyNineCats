class UsersController < ApplicationController

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in!(@user)
      redirect_to user_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def show
    if current_user.nil?
      redirect_to new_session_url
    else
      @user = current_user
      render :show
    end

  end

  protected

  def user_params
    params.require(:user).permit(:username, :password)
  end

end
