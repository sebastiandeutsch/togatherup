class GroupMembership < ApplicationRecord
  ROLES = %w[owner member].freeze

  belongs_to :group
  belongs_to :user

  validates :role, presence: true, inclusion: { in: ROLES }
  validates :joined_at, presence: true
  validates :user_id, uniqueness: { scope: :group_id }

  before_validation :default_joined_at

  private

  def default_joined_at
    self.joined_at ||= Time.current
  end
end
