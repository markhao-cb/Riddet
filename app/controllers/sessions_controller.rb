class SessionsController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_user_by_credential(user_params)
    if @user
      login!(@user)
      redirect_to user_url
    else
      flash.now[:errors] = ["Invalid Login"]
      @user = User.new(user_params)
      render :new
    end
  end

  def destroy
    @user = current_user
    @user.reset_session_token!
    logout!
    redirect_to new_session_url
  end

end
