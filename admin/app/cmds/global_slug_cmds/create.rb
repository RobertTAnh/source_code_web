module GlobalSlugCmds
  class Create
    prepend BaseCmd

    def initialize(context:, params:)
      @context = context
      @params = params
    end

    def call
      validate
      ActiveRecord::Base.transaction do
        update_primary
        create unless failure?
      end
      output
    end

    private

    attr_reader :context, :params
    
    def global_slug
      @global_slug ||= GlobalSlug.new(params)
    end

    def validate
      return if global_slug.valid?

      add_model_errors global_slug
    end

    def create
      global_slug.save!
    end

    def output
      global_slug
    end

    def update_primary
      if global_slug.primary
        old_primary = GlobalSlug.where(global_slug.as_json(only: [:sluggable_id, :sluggable_type, :primary])).last
        old_primary.update primary: false
      end
    end
  end
end

