module GlobalSlugCmds
  class Destroy
    prepend BaseCmd

    def initialize(context:, params:)
      @context = context
      @params = params
    end

    def call
      step :validate
      step :destroy
      step :output
    end

    private

    attr_reader :context, :params

    def validate
      errors.add(:base, :global_slug_not_found) unless global_slug
      errors.add(:base, :global_slug_is_primary) if global_slug.primary

      !errors.any?
    end

    def global_slug
      @global_slug ||= GlobalSlug.find_by(id: params[:id])
    end

    def destroy
      global_slug.destroy!
    end

    def output
      global_slug
    end
  end   
end
