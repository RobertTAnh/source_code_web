class AddReleaseDateToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :release_date, :datetime
  end
end
