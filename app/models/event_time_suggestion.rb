class EventTimeSuggestion < ApplicationRecord
  belongs_to :event
  has_many :votes, class_name: "EventVote", dependent: :destroy

  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validate :ends_after_starts

  def vote_summary
    votes.group(:status).count
  end

  private

  def ends_after_starts
    return if starts_at.blank? || ends_at.blank?

    errors.add(:ends_at, "must be after start time") if ends_at <= starts_at
  end
end
