module DefaultSort
  SUPPORTED_VALUE_SORTS = ["asc", "desc"]

  def apply_default_sort(scope, name, supported_fields = [], &block)
    default_sort = WebConfig.for("default_sort.#{name}")&.select{|key, value|
      supported_fields.include?(key) &&
      SUPPORTED_VALUE_SORTS.include?(value.downcase)
    }

    if default_sort
      return scope.order(default_sort)
    else
      return scope.order(created_at: "desc")
    end

    yield
  end

end
