module Admin
  module ConfigHelper
    def max_image_size_in_mb
      config = web_config('features')&.dig('uploads', 'image_max_size')&.to_i
      config.present? ? config / 1024 / 1024 : 1
    end
  end
end