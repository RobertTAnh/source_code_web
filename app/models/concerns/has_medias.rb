module HasMedias
  extend ActiveSupport::Concern
  include ::MediaCmds::Utils

  included do
    has_many_attached :featured_images
    has_many_attached :content_medias
    has_many_attached :general_medias

    # @result:
    # [{ :url }]
    #
    def get_featured_images
      legacy_images =  extra_field('media_images')&.data || []

      # TODO: get from featured_images
      self.featured_images.joins(:blob).order(created_at: :desc).
        map{|file| legacy_images << {"link" => get_absolute_direct_link(file), "content_type" => file.content_type}}

      legacy_images.uniq
    end

    def get_general_medias
      general_medias =  extra_field('general_medias')&.data || []

      self.general_medias.joins(:blob).order(created_at: :desc).
        map{|file| general_medias << {"link" => get_absolute_direct_link(file), "content_type" => file.content_type}}

      general_medias.uniq
    end
  end
end
