class AttachmentListDecorator < BaseListDecorator
  set_item_class AttachmentDecorator

  def result
    super.includes(:blob)
  end
end
