module CategoryCmds
  class Destroy
    prepend BaseCmd

    def initialize(context:, category:)
      @context = context
      @category = category
    end

    def call
      validate
      destroy_category unless failure?
      output
    end

    private

    attr_reader :context, :category

    def validate
      errors.add(:base, :category_has_children) if category.children.any?
      errors.add(:base, :category_has_categorizations) if category.categorizations.any?
    end

    def destroy_category
      category.discard!
    end

    def output
      category
    end
  end
end

