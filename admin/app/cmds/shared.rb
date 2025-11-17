module Shared
  def update_category model
    param_category_ids = extra_params[:categories] || []
    param_primary_category_id = extra_params[:primary_category]
    if param_category_ids.any? || param_primary_category_id
      param_category_ids = param_category_ids.map{|s_id| s_id.to_i }
      param_primary_category_id = param_primary_category_id ? param_primary_category_id.to_i : get_default_primary_category(param_category_ids)&.id
      param_category_ids += [param_primary_category_id.to_i] if param_primary_category_id
      param_category_ids = param_category_ids.uniq
      current_category_ids = model.categories.pluck :id
      to_delete_ids = current_category_ids - param_category_ids
      to_add_ids = param_category_ids - current_category_ids

      model.categorizations.where(category_id: to_delete_ids).delete_all
      to_add_ids.each do |c_id|
        model.categorizations.create! category_id: c_id, primary: param_primary_category_id == c_id
      end
      model.categorizations.where.not(category_id: param_primary_category_id).update_all primary: false
      model.categorizations.where(category_id: param_primary_category_id).update_all primary: true
    end
  end

  # Get default primary category except additional category
  def get_default_primary_category param_category_ids
    Category.where.not(kind: WebConfig.additional_categories_for('all').pluck("key")).where(id: param_category_ids).first
  end

  def convert_extra_fields_data
    if params[:extra_fields_attributes]
      params[:extra_fields_attributes].values.each do |x_field|
        if x_field[:data_type] == 'image'
          assign_image_url_for_extra_field(x_field)
        elsif x_field[:data_type] == 'boolean'
          assign_boolean_value_for_extra_field(x_field)
        end
      end
    end
  end

  def assign_image_url_for_extra_field(x_field)
    if x_field[:image]
      blob = ActiveStorage::Blob.create_and_upload! io: x_field[:image], filename: x_field[:image].original_filename
      image_url = get_relative_direct_link blob
      x_field[:data] = image_url
    end
    x_field.delete :image
  end

  def assign_boolean_value_for_extra_field(field)
    field[:data] = (field[:data] == "1" ? true : false)
  end
end
