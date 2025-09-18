class Event < ApplicationRecord
  belongs_to :group
  belongs_to :creator, class_name: "User"

  has_many :time_suggestions, class_name: "EventTimeSuggestion", dependent: :destroy, inverse_of: :event
  has_many :event_votes, through: :time_suggestions, source: :votes

  accepts_nested_attributes_for :time_suggestions, allow_destroy: true, reject_if: :suggestion_blank?

  validates :name, presence: true
  validate :creator_is_group_member

  private

  def creator_is_group_member
    return if group.member?(creator)

    errors.add(:creator, "must be part of the group")
  end

  def suggestion_blank?(attributes)
    attributes[:starts_at].blank? || attributes[:ends_at].blank?
  end
end
