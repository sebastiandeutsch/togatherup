class EventVote < ApplicationRecord
  enum :status, {
    available: "available",
    tentative: "tentative",
    unavailable: "unavailable"
  }, validate: true

  belongs_to :event_time_suggestion
  belongs_to :user

  validates :user_id, uniqueness: { scope: :event_time_suggestion_id }

  def status_color
    case status
    when "available"
      "emerald"
    when "tentative"
      "amber"
    else
      "rose"
    end
  end

  def traffic_light_label
    case status
    when "available"
      "I'm available"
    when "tentative"
      "Maybe"
    else
      "Can't make it"
    end
  end
end
