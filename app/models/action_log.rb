class ActionLog < ApplicationRecord
  belongs_to :actionable, polymorphic: true, optional: true
  belongs_to :actor, class_name: "User"

  enum state: { finished: 'finished', failed: 'failed', created: 'created' }

  def self.init code, actionable, data, actor_id
    object_before = actionable ? get_object_data(actionable) : {}

    ActionLog.create! code: code, actionable: actionable, action_data: data, actor_id: actor_id, object_before: object_before, state: "created"
  end

  def finish response, actionable
    self.actionable ||= actionable
    self.state = 'finished'

    unless actionable.new_record?
      object_after = ActionLog.get_object_data actionable.reload
      self.changed_data = detect_changed_data self.object_before, object_after
    end

    unless response.code.to_s.match /^2|^3/
      self.state = 'failed'
      self.error = {
        http_code: response.code,
        message: response.message
      }
    end

    self.save!
  end

  def self.get_object_data actionable
    object_data = {
      'actionable' => actionable.as_json
    }

    (actionable.class.const_defined?("LOGGABLE_RELATIONS") ? actionable.class::LOGGABLE_RELATIONS : []).each do |relation|
      object_data[relation] = actionable.send(relation).as_json
    end

    object_data
  end

  def detect_changed_data object_before, object_after
    changed_data = {}

    object_before.each do |rel, data_before|
      data_after = object_after[rel] || {}

      if rel.in? ['content', 'view', 'actionable']
        data_after.each do |key, value_after|
          value_before = data_before[key]
          if value_before != value_after
            path = [rel, key].join('.')
            changed_data[path] = [value_before, value_after]
          end
        end
      elsif rel == 'tags'
        value_before = data_before.map{|dt| dt['name']}.sort
        value_after = data_after.map{|dt| dt['name']}.sort
        if value_before != value_after
          path = rel
          changed_data[path] = [value_before, value_after]
        end
      elsif rel == 'categorizations'
        value_before = data_before.map{|dt| dt.as_json(only: ['category_id', 'primary'])}.sort_by{|dt| dt['category_id']}
        value_after = data_after.map{|dt| dt.as_json(only: ['category_id', 'primary'])}.sort_by{|dt| dt['category_id']}
        if value_before != value_after
          path = rel
          changed_data[path] = [value_before, value_after]
        end
      elsif rel == 'extra_fields'
        extra_fields_before = {}
        extra_fields_after = {}
        keys = []

        data_before.each do |extra_field|
          extra_fields_before[extra_field['key']] = extra_field['data']
          keys << extra_field['key']
        end

        data_after.each do |extra_field|
          extra_fields_after[extra_field['key']] = extra_field['data']
          keys << extra_field['key']
        end

        keys.uniq!

        keys.each do |key|
          if extra_fields_before[key] != extra_fields_after[key]
            path = [rel, key].join('.')
            changed_data[path] = [extra_fields_before[key], extra_fields_after[key]]
          end
        end
      end
    end

    changed_data
  end
end
