class Role < ApplicationRecord
  validates :name, presence: true
  has_many :granted_permissions, as: :granted_to, dependent: :destroy
  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles

  accepts_nested_attributes_for :granted_permissions, allow_destroy: true

  def self.clear_cache user_id=nil
    Rails.cache.delete_matched("permissions_of_#{user_id || '*'}")
  end
end
