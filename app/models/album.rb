class Album < ActiveRecord::Base
  include SoftDelete
  include HasSlug

  has_many_attached :files, dependent: :destroy

  validates :name, presence: true

  belongs_to :owner, polymorphic: true, optional: true

  scope :by_slug, -> (slug) { where(slug: slug) }
end

