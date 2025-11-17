module HasTableOfContent
  extend ActiveSupport::Concern

  included do
    before_save :process_table_of_content, if: :will_save_change_to_body?
  end

  private

  def process_table_of_content
    if body.present?
      data = build_table_of_content(body)

      self.body = data[:body]
      self.catalog = data[:catalog]
    else
      self.catalog = nil
    end
  end

  def build_table_of_content(body)
    return {} if body.blank?

    document = Nokogiri::HTML.fragment(body)

    catalog = []

    document.css('h2, h3').each do |heading|
      title = heading.text
      heading_id = Sluggable.new(title).to_slug

      heading.set_attribute('id', heading_id)

      catalog << {
        id: heading_id,
        name: title,
        type: heading.name
      }
    end

    {
      body: document.to_html,
      catalog: catalog
    }
  end
end
