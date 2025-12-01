class User < ApplicationRecord
  devise :database_authenticatable, :recoverable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  has_one_attached :image
  has_many :granted_permissions, as: :granted_to
  has_many :permissions, through: :granted_permissions
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: Devise.email_regexp
  validates :password, presence:     true,
                       on:           :create

  def self.from_omniauth(auth)
    User.find_by(email: auth.info.email)
  end

  def all_granted_permissions
    granted_permissions.or(
      GrantedPermission.where(granted_to_type: "Role", granted_to_id: user_roles.pluck(:role_id))
    ).includes(:permission)
  end
end
