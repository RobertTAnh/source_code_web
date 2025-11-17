module HasCategories
  extend ActiveSupport::Concern

  included do
    after_destroy :destroy_all_categorizations
  end

  def categories
    @categories ||= Category.joins(:categorizations).where(categorizations: { categorizable_type: self.class.name, categorizable_id: self.id })
  end

  def categorizations
    Categorization.where(categorizable_type: self.class.name, categorizable_id: self.id)
  end

  def destroy_all_categorizations
    categorizations.delete_all
  end

  def primary_category
    @primary_category ||= categories.find_by(categorizations: { primary: true})
  end

  def root_category
    @root_category ||= categories.find_by(categories: { parent_id: nil })
  end

  def primary_root_category
    root = primary_category

    return nil unless root

    while root.parent
      root = root.parent
    end

    root
  end
end
