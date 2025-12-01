class UpdatePublishedAtValue < ActiveRecord::Migration[7.0]
  def up
    Category.where(published_at: nil).update_all('published_at = created_at') 
    Post.where(published_at: nil).update_all('published_at = created_at')
    Product.where(published_at: nil).update_all('published_at = created_at')
  end
end
