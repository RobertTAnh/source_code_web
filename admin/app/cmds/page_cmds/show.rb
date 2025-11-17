module PageCmds
  class Show < GetBase
    prepend BaseCmd

    def call
      step :validate_params!
      step :load_page
    end

    def load_page
      page = Page.find_by(id: params[:id])
    end
  end
end
