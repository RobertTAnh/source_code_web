class Comment < ApplicationRecord
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_id', dependent: :destroy
  belongs_to :parent, class_name: 'Comment', optional: true

  belongs_to :user, optional: true
  belongs_to :owner, polymorphic: true

  enum :status, { uncensored: 'uncensored', published: 'published', rejected: 'rejected' }

  validates :name, presence: true, if: -> { !self.is_admin }
  validates :content, presence: true
  validates :rate, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }, if: -> { !self.is_admin }

  before_create :set_initial_status
  after_save :recalculate_owner_rating

  default_scope { order('created_at DESC') }

  def set_initial_status
    self.status = 'uncensored' unless self.status
  end

  def recalculate_owner_rating
    self.owner.recalculate_review_rating
  end

  def replied?
    self.replies.count > 0
  end
end
