class DashboardsController < ApplicationController
  before_action :require_login

  def show
    @groups = current_user.groups.includes(:events).order(:name)
    @upcoming_events = Event
      .where(group_id: @groups.select(:id))
      .includes(:time_suggestions, :group)
      .order(created_at: :desc)
      .limit(10)
  end
end
