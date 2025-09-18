class GroupInvitationsController < ApplicationController
  before_action :set_invitation

  def show
    if @invitation.expired?
      flash.now[:alert] = "This invitation has expired"
    elsif @invitation.accepted_at?
      flash.now[:notice] = "This invitation was already used"
    end
  end

  def accept
    unless signed_in?
      redirect_to new_session_path, alert: "Sign in or create an account to join" and return
    end

    if @invitation.expired?
      redirect_to group_invitation_path(@invitation.token), alert: "That invitation has expired" and return
    end

    group = @invitation.group

    if group.member?(current_user)
      redirect_to group_path(group), notice: "You're already part of #{group.name}"
      return
    end

    group.add_member(current_user)
    @invitation.mark_accepted!

    redirect_to group_path(group), notice: "Welcome to #{group.name}!"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to group_invitation_path(@invitation.token), alert: e.record.errors.full_messages.to_sentence
  end

  private

  def set_invitation
    @invitation = GroupInvitation.find_by!(token: params[:token])
  end
end
