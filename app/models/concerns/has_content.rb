module HasContent
  extend ActiveSupport::Concern

  included do
    has_one :content, as: :owner

    accepts_nested_attributes_for :content

    validates_associated :content

    after_create :create_content

    scope :seo_index, -> { joins(:content).where(content: { seo_index: true }) }
  end

  def create_content
    self.create_content! unless self.content
  end
end
