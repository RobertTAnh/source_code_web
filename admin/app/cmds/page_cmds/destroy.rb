module PageCmds
  class Destroy
    prepend BaseCmd

    def initialize(context:, page:)
      @context = context
      @page = page
    end

    def call
      validate
      destroy_page unless failure?
      output
    end

    private

    attr_reader :context, :page

    def validate
    end

    def destroy_page
      page.discard!
    end

    def output
      page
    end
  end
end


