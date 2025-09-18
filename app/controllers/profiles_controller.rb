class ProfilesController < ApplicationController
  before_action :require_login

  def show
    @user = current_user
    @availability_slots = current_user.availability_slots.ordered
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if params[:remove_avatar] == "1"
      @user.avatar.purge_later if @user.avatar.attached?
    end

    if @user.update(profile_params)
      redirect_to profile_path, notice: "Profile updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:name, :bio, :avatar)
  end
end
