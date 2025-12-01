class GrantedPermission < ApplicationRecord
  belongs_to :permission
  belongs_to :granted_to, polymorphic: true
  before_save :parse_json

  private
  def parse_json
    self.conditions = JSON.parse(self.conditions) if conditions.present? && conditions.is_a?(String)
  end
end
