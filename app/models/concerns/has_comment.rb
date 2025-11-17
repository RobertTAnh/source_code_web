module HasComment
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :owner, dependent: :destroy
  end

  def recalculate_review_rating
    if self.respond_to? :review_rating
      self.review_rating = comments.where(is_admin: false).average(:rate).to_i
      save!
    end
  end
end
