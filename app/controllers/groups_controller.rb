class GroupsController < ApplicationController
  before_action :require_login
  before_action :set_group, only: %i[show edit update destroy]
  before_action :ensure_member!, only: %i[show]
  before_action :ensure_owner!, only: %i[edit update destroy]

  def index
    @owned_groups = current_user.owned_groups.includes(:members)
    @member_groups = current_user.groups.where.not(owner_id: current_user.id).includes(:owner)
    @group = Group.new
  end

  def new
    @group = Group.new
  end

  def create
    @group = current_user.owned_groups.new(group_params)

    if @group.save
      redirect_to group_path(@group), notice: "Group created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @memberships = @group.group_memberships.includes(:user)
    @events = @group.events.includes(:time_suggestions).order(created_at: :desc)
    @event = @group.events.new
    (3 - @event.time_suggestions.size).times { @event.time_suggestions.build }
    @invitation = @group.invitations.new
    @active_invitations = @group.invitations.active.order(created_at: :desc)
  end

  def edit; end

  def update
    if @group.update(group_params)
      redirect_to group_path(@group), notice: "Group updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_path, notice: "Group deleted"
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def ensure_member!
    return if @group.member?(current_user)

    redirect_to groups_path, alert: "You are not part of that group"
  end

  def ensure_owner!
    return if @group.owner == current_user

    redirect_to group_path(@group), alert: "Only owners can do that"
  end

  def group_params
    params.require(:group).permit(:name, :description)
  end
end
