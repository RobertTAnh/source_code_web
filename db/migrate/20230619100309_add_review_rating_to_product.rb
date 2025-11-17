class AddReviewRatingToProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :review_rating, :float
  end
end
