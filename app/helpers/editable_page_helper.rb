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

  def process_editable_html(element)
    id = element.get_attribute('id')
    return unless id.present?
    content = custom_page_content_for(id)
    return unless content.present?
    element.inner_html = sanitize(
      content,
      tags: %w(p span strong em u b i br ul ol li a div h1 h2 h3 h4 h5 h6),
      attributes: %w(style class href)
    )
  end

  def process_editable_background(element)
    id = element.get_attribute('id')

    return unless id.present?

    content = custom_page_content_for(id)

    return unless content.present?

    current_style = element.get_attribute('style') || ''
    
    new_style = if current_style.include?('background-image')
      current_style.gsub(/background-image:[^;]*/, "background-image: url(#{content})")
    else
      "#{current_style.present? ? "#{current_style}; " : ''}background-image: url(#{content})"
    end
    
    element.set_attribute('style', new_style)
  end

  def fill_custom_page_content(content)
    return content unless custom_page_content.present?

    fragment = Nokogiri::HTML.fragment(content)

    fragment.css('.wk-editable-text').each do |element|
      process_editable_text element
    end

    fragment.css('.wk-editable-html').each do |element|
      process_editable_html element
    end

    fragment.css('.wk-editable-link').each do |element|
      process_editable_link element
    end

    fragment.css('.wk-editable-image').each do |element|
      process_editable_image element
    end

    fragment.css('.wk-editable-background').each do |element|
      process_editable_background element
    end

    fragment.to_html
  end
end
