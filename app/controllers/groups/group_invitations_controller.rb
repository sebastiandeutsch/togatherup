module Groups
  class GroupInvitationsController < ApplicationController
    before_action :require_login
    before_action :set_group
    before_action :ensure_owner!
    before_action :set_invitation, only: :destroy

    def index
      @invitations = @group.invitations.order(created_at: :desc)
      @invitation = @group.invitations.new
    end

    def create
      @invitation = @group.invitations.new(invitation_params.merge(sender: current_user))

      if @invitation.save
        redirect_to group_group_invitations_path(@group), notice: "Invitation link generated"
      else
        @invitations = @group.invitations.order(created_at: :desc)
        render :index, status: :unprocessable_entity
      end
    end

    def destroy
      @invitation.destroy
      redirect_to group_group_invitations_path(@group), notice: "Invitation revoked"
    end

    private

    def set_group
      @group = Group.find(params[:group_id])
    end

    def ensure_owner!
      return if @group.owner == current_user

      redirect_to group_path(@group), alert: "Only owners can manage invitations"
    end

    def set_invitation
      @invitation = @group.invitations.find(params[:id])
    end

    def invitation_params
      params.require(:group_invitation).permit(:email)
    end
  end
end
