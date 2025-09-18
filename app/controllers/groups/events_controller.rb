module Groups
  class EventsController < ApplicationController
    before_action :require_login
    before_action :set_group
    before_action :ensure_member!
    before_action :set_event, only: %i[show edit update destroy]
    before_action :ensure_event_owner!, only: %i[edit update destroy]

    def index
      @events = @group.events.includes(:time_suggestions).order(created_at: :desc)
    end

    def show
      @suggestions = @event.time_suggestions.includes(votes: :user).order(:starts_at)
    end

    def new
      @event = @group.events.new
      (3 - @event.time_suggestions.size).times { @event.time_suggestions.build }
    end

    def create
      @event = @group.events.new(event_params.merge(creator: current_user))

      if @event.save
        redirect_to group_event_path(@group, @event), notice: "Event created"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @event.time_suggestions.build while @event.time_suggestions.size < 3
    end

    def update
      if @event.update(event_params)
        redirect_to group_event_path(@group, @event), notice: "Event updated"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @event.destroy
      redirect_to group_path(@group), notice: "Event deleted"
    end

    private

    def set_group
      @group = Group.find(params[:group_id])
    end

    def set_event
      @event = @group.events.find(params[:id])
    end

    def ensure_member!
      return if @group.member?(current_user)

      redirect_to groups_path, alert: "You need to join that group first"
    end

    def ensure_event_owner!
      return if @event.creator == current_user || @group.owner == current_user

      redirect_to group_event_path(@group, @event), alert: "Only the creator or owner can update this"
    end

    def event_params
      params.require(:event).permit(:name, :description, :require_everyone, :requires_contribution,
        time_suggestions_attributes: %i[id starts_at ends_at _destroy])
    end
  end
end
