class Group < ApplicationRecord
  belongs_to :owner, class_name: "User"

  has_many :group_memberships, dependent: :destroy
  has_many :members, through: :group_memberships, source: :user
  has_many :invitations, class_name: "GroupInvitation", dependent: :destroy
  has_many :events, dependent: :destroy

  validates :name, presence: true

  after_create :ensure_owner_membership

  def add_member(user, role: "member")
    membership = group_memberships.find_or_initialize_by(user:)
    membership.role = role if membership.new_record? || role == "owner"
    membership.joined_at ||= Time.current
    membership.save!
    membership
  end

  def member?(user)
    members.exists?(user.id)
  end

  private

  def ensure_owner_membership
    return if member?(owner)

    add_member(owner, role: "owner")
  end
end
