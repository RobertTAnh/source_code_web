module AlbumCmds
  class Create
    prepend BaseCmd

    def initialize(context:, params:)
      @context = context
      @params = params
    end

    def call
      validate
      create unless failure?
      output
    end

    private

    attr_reader :context, :params
    
    def album
      @album ||= Album.new(params)
    end

    def validate
      return if album.valid?

      add_model_errors album
    end

    def create
      album.save!
    end

    def output
      album
    end
  end
end
