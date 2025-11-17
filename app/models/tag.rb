class Tag < ApplicationRecord
  belongs_to :owner, polymorphic: true

  after_save :reload_owner_tags

  def reload_owner_tags
    return unless self.saved_changes?

    self.owner&.reload_tags
  end
end
