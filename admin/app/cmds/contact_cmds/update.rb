module ContactCmds
  class Update
    prepend BaseCmd

    def initialize(context:, contact:, params:)
      @context = context
      @contact = contact
      @params = params
    end

    def call
      validate
      update unless failure?
      output
    end

    private

    attr_reader :context, :params, :contact

    def validate
      contact.assign_attributes(params)

      return if contact.valid?

      add_model_errors contact
    end

    def update
      contact.save!
    end

    def output
      contact
    end
  end
end
