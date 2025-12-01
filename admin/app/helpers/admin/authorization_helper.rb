module Admin
  module AuthorizationHelper
    extend ActiveSupport::Concern

    def can?(action, resource)
      if resource.is_a?(ActiveRecord::Base)
        resource_class = resource.class
        record = resource
      else
        resource_class = resource.to_s.camelcase.constantize
        record = nil
      end

      AuthPolicy.new(context, resource_class).able_to(action.to_s, record)
    end

    def scoped(action, resource)
      AuthPolicy.new(context, resource.to_s.camelcase.constantize).build_scope action.to_s
    end
  end
end
