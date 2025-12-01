class AuthPolicy
  attr_reader :user, :relation, :context

  def initialize context, relation
    @context = context
    @user = context[:user]
    @relation = relation.is_a?(Class) ? relation : relation.constantize
  end

  def build_scope name
    if self.load_permissions["*"] == "*"
      query = "(1=1)"
    else
      permissions = (self.load_permissions[name] || []) + (self.load_permissions["*"] || [])
      if permissions.present?
        query = permissions.map{|granted_permission| load_scope(granted_permission)}.join(" OR ")
      else
        query = "(1=0)"
      end
    end

    relation.where(query)
  end

  def able_to name, record=nil
    if self.load_permissions["*"] == "*"
      return true
    else
      if record
        return build_scope(name).where(id: record.id).exists?
      else
        permissions = (self.load_permissions[name] || []) + (self.load_permissions["*"] || [])
        return true if permissions.present?
      end
    end

    return false
  end

  def user_permissions
    grouped_permissions = Rails.cache.fetch("permissions_of_#{user.id}", expires_in: 6.hours) do
      group_permissions = {}
      user.all_granted_permissions.joins(:permission).
        select("granted_permissions.*, permissions.name as name, permissions.granted_on as granted_on").
        group_by{|gp| gp.granted_on}.each do |granted_on, granted_permissions|
          group_permissions[granted_on] = granted_permissions.group_by{|gp| gp.name}
        end
      group_permissions
    end
  end

  def load_permissions
    @permissions ||= if user_permissions["*"]
      { "*" => "*" }
    else
      user_permissions[relation.to_s] || {}
    end
  end

  def read_condition condition
    if condition.present?
      sub_queries = []
      logical_operator = condition["logical_operator"]
      matchers = condition["matchers"]
      matchers&.each do |matcher|
        if matcher["matchers"]
          sub_queries << read_condition(matcher)
        else
          sub_queries << read_matcher(matcher)
        end
      end

      if sub_queries.present?
        "(" + sub_queries.join(" #{logical_operator} ") + ")"
      else
        "(1=1)"
      end
    else
      "(1=1)"
    end
  end

  def read_matcher matcher
    sub_query = ''
    case matcher["kind"]
    when "belong_to_category"
      sub_query = Matcher::BelongToCategory.new.process relation, matcher
    else
      sub_query = Matcher::ResourceQuery.new.process relation, matcher
    end

    sub_query
  end

  def load_scope granted_permission
    sub_queries = []
    sub_queries << read_condition(granted_permission.conditions)
    sub_queries.join(" AND ")
  end
end
