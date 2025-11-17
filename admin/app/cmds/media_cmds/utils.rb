module MediaCmds
  module Utils
    def folder_for key
      [ key[0..1], key[2..3] ].join("/")
    end

    def get_relative_direct_link blob
      key_path = folder_for(blob.key) + '/' + blob.key

      ActionController::Base.helpers.asset_path(
        "/storage/#{key_path}"
      )
    end

    def get_absolute_direct_link blob
      key_path = folder_for(blob.key) + '/' + blob.key

      ActionController::Base.helpers.asset_path(
        "/storage/#{key_path}"
      )
    end
  end
end
