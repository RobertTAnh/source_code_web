class Permission < ApplicationRecord
  has_many :granted_permissions, dependent: :destroy
end
