module PageOps
  class Page < BaseOperation
    def call
      validate_params

      get_page

      prepare_data

      render_view
    end

    private

    attr_reader :page

    def validate_params
    end

    def get_page
      @page = ::Page.find_by slug: context.params[:page]
    end

    def prepare_data
      context.instance_variable_set '@page', page
      context.instance_variable_set '@content', page.content
    end

    def render_view
      context.render_for page
    end
  end
end
