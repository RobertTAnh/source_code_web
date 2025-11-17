module EditablePageHelper
  def custom_page_content
    return unless content

    @custom_page_content ||= PageContent.display_data_for(content.owner)
  end

  def custom_page_content_for(eid)
    custom_page_content[eid]
  end

  def process_editable_text(element)
    id = element.get_attribute('id')

    return unless id.present?

    content = custom_page_content_for(id)

    return unless content.present?

    element.content = content
  end

  def process_editable_link(element)
    id = element.get_attribute('id')

    return unless id.present?

    content = custom_page_content_for(id)

    return unless content.present?

    element.set_attribute('href', content['target']) if content['target'].present?

    if (text = element.css('.wk-text').first) && content['text'].present?
      text.content = content['text']
    end

    if (image = element.css('.wk-image').first) && content['image'].present?
      image.set_attribute 'src', content['image']
    end

    element.content = content['text'] unless text || image || content['text'].blank?
  end

  def process_editable_image(element)
    id = element.get_attribute('id')

    return unless id.present?

    content = custom_page_content_for(id)

    return unless content.present?

    element.set_attribute 'src', content
  end

  def fill_custom_page_content(content)
    return content unless custom_page_content.present?

    fragment = Nokogiri::HTML.fragment(content)

    fragment.css('.wk-editable-text').each do |element|
      process_editable_text element
    end

    fragment.css('.wk-editable-link').each do |element|
      process_editable_link element
    end

    fragment.css('.wk-editable-image').each do |element|
      process_editable_image element
    end

    fragment.to_html
  end
end
