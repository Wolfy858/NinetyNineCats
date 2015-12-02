class SessionsController < ApplicationController

  def new
    render :new
  end

  def create

    @user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password])

    if @user.nil?

      render :new
    else
      log_in!(@user)
      redirect_to cats_url
    end
  end

end
