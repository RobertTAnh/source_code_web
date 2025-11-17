module HasAlbum
  extend ActiveSupport::Concern

  included do
    has_many :albums, as: :owner, dependent: :destroy
    accepts_nested_attributes_for :albums, allow_destroy: true
  end
end
