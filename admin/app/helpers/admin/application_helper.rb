module Admin
  module ApplicationHelper
    include ::MediaCmds::Utils
    
    def all_categories_select_options(categories, prefix)
      options = categories.select('id, name').flat_map do |category|
        [
          ["#{prefix}#{category.name}", category.id],
          * (category.children.any? ? all_categories_select_options(category.children, "#{prefix}-- ") : [])
        ]
      end
      options.compact
    end

    def get_album_files model
      model.files.
        joins(:blob).where("active_storage_blobs.content_type in (?)", ActiveStorage.variable_content_types).order(created_at: :desc).
        map{|file| {url: get_absolute_direct_link(file), filename: file.filename, key: file.key, created_at: file.created_at, size: file.byte_size}}
    end

    def get_featured_images model
      model.featured_images.
        joins(:blob).where("active_storage_blobs.content_type in (?)", ActiveStorage.variable_content_types).order(created_at: :desc).
        map{|file| {url: get_absolute_direct_link(file), filename: file.filename, key: file.key, created_at: file.created_at, size: file.byte_size}}
    end

    def get_general_medias model
      model.general_medias.
        joins(:blob).where("active_storage_blobs.content_type in (?)", ActiveStorage.variable_content_types).order(created_at: :desc).
        map{|file| {url: get_absolute_direct_link(file), filename: file.filename, key: file.key, created_at: file.created_at, size: file.byte_size}}
    end

    def format_datetime datetime
      datetime.strftime("%d/%m/%Y %R")
    end

    def format_date datetime
      datetime.strftime("%d/%m/%Y")
    end

    def meta_count records
      r_length = records.count
      start_p  = r_length.zero? ? 0 : (records.current_page - 1) * records.limit_value + 1
      end_p    = r_length.zero? ? 0 : r_length + start_p - 1
      "Showing #{start_p} to #{end_p} of #{records.total_count} entries"
    end

    def pages_view_options records
      index_columns = [
        { column_name: :image, human_column_name: "Image" },
        { column_name: :name, human_column_name: "Name" },
        { column_name: :slug, human_column_name: "Slug" },
        { column_name: :created_at, human_column_name: "Created At" },
        { column_name: :status, human_column_name: "Status" },
        { column_name: :seo_index, human_column_name: "Seo Index" }
      ]

      index_data_table = records.map do |record|
        {
          image: record.image_url ? image_tag(record.image_url, width: 86) : nil,
          created_at: format_date(record.created_at),
          name: link_to(record.name, send("edit_#{record.class.name.downcase}_path", record)),
          slug: record.slug,
          status: record.status && record.status.camelize,
          seo_index: record.content.seo_index ? "Index" : "NoIndex",
          _record: record
        }
      end

      {
        index_columns: index_columns,
        index_actions: [:customer_show, :edit, :destroy],
        index_data_table: index_data_table,
        createable: true
      }
    end

    def products_view_options records

      index_columns = [
        { column_name: :image, human_column_name: "Image" },
        { column_name: :name, human_column_name: "Name" },
        { column_name: :slug, human_column_name: "Slug" },
        default_column_sort,
        { column_name: :category, human_column_name: "Category" },
        { column_name: :status, human_column_name: "Status" },
        { column_name: :seo_index, human_column_name: "Seo Index" },
      ]

      index_data_table = records.map do |record|
        {
          image: record.image_url ? image_tag(record.image_url, width: 86) : nil,
          created_at: format_date(record.created_at),
          published_at: format_date(record.published_at),
          category: record.primary_category.try(:name),
          name: link_to(record.name, send("edit_#{record.class.name.downcase}_path", record)),
          slug: record.slug,
          status: record.status && record.status.camelize,
          seo_index: record.content.seo_index ? "Index" : "NoIndex",
          display_order: record.display_order,
          _record: record
        }
      end

      {
        index_columns: index_columns,
        index_actions: [:customer_show, :edit, :destroy],
        index_data_table: index_data_table,
        createable: true
      }
    end

    def posts_view_options records

      index_columns = [
        { column_name: :image, human_column_name: "Image" },
        { column_name: :name, human_column_name: "Name" },
        { column_name: :slug, human_column_name: "Slug" },
        default_column_sort,
        { column_name: :category, human_column_name: "Category" },
        { column_name: :status, human_column_name: "Status" },
        { column_name: :seo_index, human_column_name: "Seo Index" },
      ]

      index_data_table = records.map do |record|
        {
          image: record.image_url ? image_tag(record.image_url, width: 86) : nil,
          created_at: format_date(record.created_at),
          category: record.primary_category.try(:name),
          published_at: format_date(record.published_at),
          name: link_to(record.name, send("edit_#{record.class.name.downcase}_path", record)),
          slug: record.slug,
          status: record.status && record.status.camelize,
          seo_index: record.content.seo_index ? "Index" : "NoIndex",
          display_order: record.display_order,
          _record: record
        }
      end

      {
        index_columns: index_columns,
        index_actions: [:customer_show, :edit, :destroy],
        index_data_table: index_data_table,
        createable: true
      }
    end

    def resources_view_options records, resource_config
      index_columns = [{ column_name: :image, human_column_name: "Image" }]
      index_columns = index_columns.concat([
        { column_name: :name, human_column_name: "Name" }
      ])
      if resource_config[:has_slug]
        index_columns = index_columns.concat([
          { column_name: :slug, human_column_name: "Slug" },
          { column_name: :status, human_column_name: "Status" },
          { column_name: :seo_index, human_column_name: "Seo Index" }
        ])
      end

      (resource_config[:attributes] || []).each do |config|
        if config[:listable]
          index_columns << { column_name: "properties_#{config[:key]}".to_sym, human_column_name: config[:name] }
        end
      end

      index_columns << { column_name: :created_at, human_column_name: "Created At" }

      index_data_table = records.map do |record|
        data = { _record: record }
        index_columns.each do |column_config|
          if column_config[:column_name].to_s.match(/\Aproperties_/)
            data[column_config[:column_name]] = ((record.properties || {})[column_config[:column_name].to_s.split('properties_').last] || {})["data"]
          else
            if column_config[:column_name] == :image
              data[column_config[:column_name]] = record.image_url ? image_tag(record.image_url, width: 86) : nil
            elsif column_config[:column_name] == :name
              data[column_config[:column_name]] = link_to(record.name, send("edit_#{record.class.name.downcase}_path", record))
            elsif column_config[:column_name] == :seo_index
              data[column_config[:column_name]] = record.content.seo_index ? "Index" : "NoIndex"
            elsif column_config[:column_name].match(/_at$/)
              data[column_config[:column_name]] = format_date(record.send(column_config[:column_name]))
            else
              data[column_config[:column_name]] = record.send(column_config[:column_name])
            end
          end
        end
        data
      end

      {
        index_columns: index_columns,
        index_actions: resource_config[:has_slug] ? [:customer_show, :edit, :destroy] : [:edit, :destroy],
        index_data_table: index_data_table,
        createable: true
      }
    end

    def orders_view_options records
      index_columns = [
        { column_name: :code, human_column_name: "Code" },
        { column_name: :customer_name, human_column_name: "Customer name" },
        { column_name: :customer_email, human_column_name: "Email" },
        { column_name: :customer_phone, human_column_name: "Phone" },
        { column_name: :total_price, human_column_name: "Total price(VND)" },
        { column_name: :status, human_column_name: "Status" },
        { column_name: :order_date, human_column_name: "Order date" }
      ]

      index_data_table = records.map do |record|
        {
          code: link_to(record.code, send("#{record.class.name.downcase}_path", record)),
          order_date: format_date(record.created_at),
          customer_name: record.customer_name,
          customer_email: record.customer_email,
          customer_phone: record.customer_phone,
          total_price: record.total_price,
          status: record.status,
          _record: record
        }
      end

      {
        index_columns: index_columns,
        index_actions: [:show, :destroy],
        index_data_table: index_data_table,
        createable: false
      }
    end

    def users_view_options records
      index_columns = [
        { column_name: :image, human_column_name: "Image" },
        { column_name: :name, human_column_name: "Name" },
        { column_name: :email, human_column_name: "Email" },
        { column_name: :created_at, human_column_name: "Created At" },
      ]

      index_data_table = records.map do |record|
        {
          image: record.image_url ? image_tag(record.image_url, width: 86) : nil,
          created_at: format_date(record.created_at),
          email: record.email,
          name: link_to(record.name, send("edit_#{record.class.name.downcase}_path", record)),
          _record: record
        }
      end

      {
        index_columns: index_columns,
        index_actions: [:customer_show, :edit, :destroy],
        index_data_table: index_data_table,
        createable: true
      }
    end

    def roles_view_options records
      index_columns = [
        { column_name: :name, human_column_name: "Name" },
        { column_name: :created_at, human_column_name: "Created At" },
        { column_name: :description, human_column_name: "Description" },
      ]

      index_data_table = records.map do |record|
        {
          created_at: format_date(record.created_at),
          description: record.description,
          name: link_to(record.name, edit_role_path(record)),
          _record: record
        }
      end

      {
        index_columns: index_columns,
        index_actions: [:edit, :destroy],
        index_data_table: index_data_table,
        createable: true
      }
    end

    def contacts_view_options records
      columns_config = WebConfig.for "admin.contacts_list.display_fields" || []
      columns_config = columns_config.split(',').map(&:strip) if columns_config.is_a?(String)
      index_columns = columns_config.map do |col|
        if matched = col.match(/^(\w+)\[(.+)\]$/)
          { column_name: col, human_column_name: matched[2] }
        else col.match(/^\w+$/)
          { column_name: col, human_column_name: col.to_s.humanize }
        end
      end

      index_data_table = records.map do |record|
        res = {
          _record: record
        }

        index_columns.each do |col|
          field = col[:column_name]
          if matched = field.match(/^(\w+)\[(.+)\]$/)
            res[field] = (record.send(matched[1]) || {})[matched[2]]
          elsif field.match(/^\w+$/)
            if field.match /_at$/
              res[field] = format_date record.send(field.to_s)
            elsif field == :name
              res[field] = link_to(record.name, send("edit_#{record.class.name.downcase}_path", record))
            else
              res[field] = record.send(field.to_s)
            end
          end
        end
        res
      end

      {
        index_columns: index_columns,
        index_actions: [:edit, :destroy],
        index_data_table: index_data_table
      }
    end

    def albums_view_options records
      index_columns = [
        { column_name: :name, human_column_name: "Name" },
        { column_name: :slug, human_column_name: "Slug" },
        { column_name: :total_files, human_column_name: "Total Files" },
        { column_name: :created_at, human_column_name: "Created At" },
      ]

      index_data_table = records.map do |record|
        {
          created_at: format_date(record.created_at),
          name: link_to(record.name, send("edit_#{record.class.name.downcase}_path", record)),
          slug: record.slug,
          total_files: record.files.count,
          _record: record
        }
      end

      {
        index_columns: index_columns,
        index_actions: [:edit, :destroy],
        index_data_table: index_data_table,
        createable: true
      }
    end

    def json_input_display(value)
      return value.to_json if value.is_a?(Hash) || value.is_a?(Array)

      value
    end

    def language_list
      I18n.available_locales.map do |locale|
        {
          name: t("common.languages.#{locale.to_s}"),
          code: locale.to_s
        }
      end
    end

    def field_label_mapper name
      if name.match /updated_at$/
        nil
      elsif name.match /^actionable\./
        name.split('.')[-1].humanize
      elsif name == 'categorizations'
        'Category'
      elsif name.match /^content\./
        'Content'
      else
        name.humanize
      end
    end

    def load_resource_permissions
      result = {}
      Permission.all.each do |p|
        result[p.granted_on] = [] if result[p.granted_on].nil?
        result[p.granted_on] << {id: p.id, name: p.name}.as_json
      end

      result
    end

    def default_column_sort
      default_sort = WebConfig.for("default_sort.#{controller_name}")
      column_sort = { column_name: :created_at, human_column_name: "Created At" }
      if default_sort
        field_sort = default_sort&.keys&.first

        column_sort = { column_name: field_sort.to_sym, human_column_name: field_sort.titleize }
      end

      column_sort
    end
  end
end
