class GroupMembershipsController < ApplicationController
  before_action :require_login
  before_action :set_group
  before_action :set_membership

  def destroy
    if @membership.user == current_user
      if @group.owner == current_user
        redirect_to group_path(@group), alert: "Group owners cannot leave their own group"
        return
      end

      @membership.destroy
      redirect_to groups_path, notice: "You left the group"
    elsif @group.owner == current_user
      @membership.destroy
      redirect_to group_path(@group), notice: "Member removed"
    else
      redirect_to group_path(@group), alert: "You don't have permission to do that"
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_membership
    @membership = @group.group_memberships.find(params[:id])
  end
end
