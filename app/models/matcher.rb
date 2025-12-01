module Matcher
  class BelongToCategory
    def process relation, matcher
      value = matcher["value"].is_a?(Array) ? matcher["value"] : [matcher["value"]]
      category_ids = value + descendant_category_ids(value)
      relation_ids = Categorization.where(category_id: category_ids, categorizable_type: relation.to_s).pluck(:categorizable_id).uniq
      if relation_ids.blank?
        sub_query = "1=0"
      else
        sub_query = "#{relation.table_name}.id in (#{relation_ids.join(',')})"
      end

      sub_query
    end

    def descendant_category_ids category_ids
      parent_ids = category_ids
      result = []
      4.times.each do
        parent_ids = Category.where(parent_id: parent_ids).pluck(:id)
        result.concat(parent_ids)
      end

      result
    end
  end

  class ResourceQuery
    def process relation, matcher
      field = matcher["field"]
      relational_operator = matcher["relational_operator"] || "in"
      value = matcher["value"]

      case relational_operator
      when "in"
        if value.blank?
          sub_query = "1=1"
        else
          sub_query = "#{relation.table_name}.#{field} in (#{value.is_a?(Array) ? value.join(',') : value})"
        end
      end
      sub_query
    end
  end
end
