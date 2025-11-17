class AlbumDecorator < BaseDecorator
  def files
    AttachmentListDecorator.new(super)
  end
end
