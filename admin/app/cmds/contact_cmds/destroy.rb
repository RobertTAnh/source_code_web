module ContactCmds
  class Destroy
    prepend BaseCmd

    def initialize(context:, contact:)
      @context = context
      @contact = contact
    end

    def call
      validate
      destroy_contact unless failure?
      output
    end

    private

    attr_reader :context, :contact

    def validate
    end

    def destroy_contact
      contact.discard!
    end

    def output
      contact
    end
  end
end
