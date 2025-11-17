module AlbumCmds
  class Destroy
    prepend BaseCmd

    def initialize(context:, album:)
      @context = context
      @album = album
    end

    def call
      validate
      destroy_album unless failure?
      output
    end

    private

    attr_reader :context, :album

    def validate
    end

    def destroy_album
      album.discard!
    end

    def output
      album
    end
  end
end

