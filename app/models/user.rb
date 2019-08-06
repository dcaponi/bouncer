class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true

  def set_email_confirm_token
    if self.email_confirm_token.blank?
      self.email_confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end

  def validate_email
    self.email_confirm_token = nil
  end

  def is_validated_user?
    self.email_confirm_token.nil?
  end
end
