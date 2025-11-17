module AlbumCmds
  class Update
    prepend BaseCmd

    def initialize(context:, album:, params:)
      @context = context
      @album = album
      @params = params
    end

    def call
      validate
      update unless failure?
      output
    end

    private

    attr_reader :context, :params, :album

    def validate
      album.assign_attributes(params)

      return if album.valid?

      add_model_errors album
    end

    def update
      album.save!
    end

    def output
      album
    end
  end
end
