class EventVotesController < ApplicationController
  before_action :require_login
  before_action :set_suggestion
  before_action :ensure_group_member!

  def create
    upsert_vote
  end

  def update
    upsert_vote
  end

  private

  def upsert_vote
    vote = @suggestion.votes.find_or_initialize_by(user: current_user)
    vote.assign_attributes(vote_params)

    if vote.save
      redirect_to group_event_path(@suggestion.event.group, @suggestion.event), notice: "Availability updated"
    else
      redirect_to group_event_path(@suggestion.event.group, @suggestion.event), alert: vote.errors.full_messages.to_sentence
    end
  end

  def set_suggestion
    @suggestion = EventTimeSuggestion.find(params[:event_time_suggestion_id])
  end

  def vote_params
    params.require(:event_vote).permit(:status, :note)
  end

  def ensure_group_member!
    return if @suggestion.event.group.member?(current_user)

    redirect_to group_path(@suggestion.event.group), alert: "Join the group to vote on times"
  end
end
