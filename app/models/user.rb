class User < ApplicationRecord
  has_secure_password

  has_one_attached :avatar

  has_many :availability_slots, dependent: :destroy
  has_many :owned_groups, class_name: "Group", foreign_key: :owner_id, dependent: :destroy
  has_many :group_memberships, dependent: :destroy
  has_many :groups, through: :group_memberships
  has_many :sent_invitations, class_name: "GroupInvitation", foreign_key: :sender_id, dependent: :destroy
  has_many :event_votes, dependent: :destroy
  has_many :created_events, class_name: "Event", foreign_key: :creator_id, dependent: :nullify

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 12 }, allow_nil: true

  def member_of?(group)
    groups.exists?(group.id)
  end

  def avatar_variant(size: 120)
    return avatar unless avatar.attached?

    avatar.variant(resize_to_fill: [size, size])
  end
end
