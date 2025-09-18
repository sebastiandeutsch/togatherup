class GroupInvitation < ApplicationRecord
  TOKEN_LENGTH = 24
  EXPIRATION_DAYS = 14

  belongs_to :group
  belongs_to :sender, class_name: "User"

  validates :token, presence: true, uniqueness: true
  validates :expires_at, presence: true
  validates :email, allow_blank: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_validation :ensure_token
  before_validation :set_expiration

  scope :active, -> { where(accepted_at: nil).where("expires_at > ?", Time.current) }

  def expired?
    expires_at.present? && expires_at <= Time.current
  end

  def mark_accepted!
    update!(accepted_at: Time.current)
  end

  private

  def ensure_token
    return if token.present?

    self.token = loop do
      candidate = SecureRandom.urlsafe_base64(TOKEN_LENGTH)
      break candidate unless self.class.exists?(token: candidate)
    end
  end

  def set_expiration
    self.expires_at ||= EXPIRATION_DAYS.days.from_now
  end
end
