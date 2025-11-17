module SoftDelete
  extend ActiveSupport::Concern

  included do
    include Discard::Model
    default_scope -> { kept }

    after_discard do
      if self.class.include?(HasGlobalSlug)
        global_slugs.discard_all!
      end
    end

    after_destroy do
      if self.class.include?(HasGlobalSlug)
        global_slugs.with_discarded.destroy_all
      end
    end
  end
end
