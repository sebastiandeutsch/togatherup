class RegistrationsController < ApplicationController
  def new
    if signed_in?
      redirect_to dashboard_path, notice: "You are already registered"
      return
    end
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to profile_path, notice: "Welcome to ToGatherUp!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
