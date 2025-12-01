module HasPublishedAt
  extend ActiveSupport::Concern

  included do
    before_create :set_published_at
    before_save :update_published_at
    scope :published_lastest, -> { published.order(published_at: :desc) }
  end

  private
  def set_published_at
    self.published_at ||= self.created_at
  end

  def update_published_at
    if !self.published_at
      self.published_at ||= self.created_at
    end
  end
end
