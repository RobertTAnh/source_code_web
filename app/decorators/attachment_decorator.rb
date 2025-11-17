class AttachmentDecorator < BaseDecorator
  include MediaCmds::Utils

  def link
    get_absolute_direct_link(blob)
  end
end
