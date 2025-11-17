module CustomHtmlCmds
  class Process
    def initialize(obj:, extra_params:)
      @obj = obj
      @extra_params = extra_params
    end

    def valid?
      return !@extra_params[:custom_html] || (@extra_params[:custom_html] && !!@extra_params[:custom_html].content_type.match(/html/))
    end

    def process
      process_custom_html
    end

    private

    attr_reader :obj, :extra_params

    def delete_view
      if custom_view = obj.view
        obj.update! view_id: nil
        custom_view.destroy
      end
    end

    def update_view
      file_data = extra_params[:custom_html]
      if file_data.respond_to?(:read)
        template = file_data.read
      else
        template = File.read(file_data.path)
      end

      if custom_view = obj.view
        custom_view.name = file_data.original_filename
        custom_view.code = [Time.now.to_i, file_data.original_filename].join('-')
        custom_view.template = template
        custom_view.save!
      else
        view = View.create! theme_id: Theme.current.id, name: file_data.original_filename,
          code: [Time.now.to_i, file_data.original_filename].join('-'), template_format: 'html', template: template
        obj.update! view_id: view.id
      end
    end

    def process_custom_html
      if extra_params[:custom_html]
        update_view
      elsif extra_params[:delete_custom_html]
        delete_view
      end
    end
  end
end
