class User < ApplicationRecord
  devise :database_authenticatable, :recoverable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  has_one_attached :image

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: Devise.email_regexp
  validates :password, presence:     true,
                       on:           :create

  def self.from_omniauth(auth)
    User.find_by(email: auth.info.email)
  end
end
