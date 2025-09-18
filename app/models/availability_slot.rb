class AvailabilitySlot < ApplicationRecord
  DAYS_OF_WEEK = {
    sunday: 0,
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6
  }.freeze

  belongs_to :user

  enum :day_of_week, DAYS_OF_WEEK

  validates :day_of_week, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validate :ends_after_starts

  scope :ordered, -> { order(:day_of_week, :starts_at) }

  private

  def ends_after_starts
    return if starts_at.blank? || ends_at.blank?

    errors.add(:ends_at, "must be after start time") if ends_at <= starts_at
  end
end
