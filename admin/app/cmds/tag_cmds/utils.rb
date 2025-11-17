module TagCmds
  module Utils
    def create_params_with_tags params
      if params[:tags].present?
        tags_attr = params[:tags].reject { |t| t.empty? }.map { |tag| { name: tag } }
        params[:tags_attributes] = tags_attr
        params.except(:tags)
      else
        params
      end
    end

    def update_params_with_tags obj, params
      if params[:tags].present?
        params[:tags].reject! { |t| t.empty? }

        tags_attr = obj.tags.map do |tag|
          if params[:tags].include? tag.name
            { id: tag.id, name: tag.name, _destroy: 0 }
          else
            { id: tag.id, name: tag.name, _destroy: 1 }
          end
        end

        new_tag = params[:tags] - obj.tag_names

        new_tag.each do |tag|
          tags_attr << { name: tag, _destroy: 0 }
        end

        params[:tags_attributes] = tags_attr
        params.except(:tags)
      else
        params
      end
    end
  end
end
