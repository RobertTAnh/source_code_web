permissions = {
  "*" => ["*"],
  "Category" => ["create", "read", "update", "delete", "*"],
  "Product" => ["create", "read", "update", "delete", "*"],
  "Post" => ["create", "read", "update", "delete", "*"],
  "Page" => ["create", "read", "update", "delete", "*"],
  "Contact" => ["read", "update", "delete", "*"],
  "Order" => ["read", "update", "delete", "*"],
  "Album" => ["create", "read", "update", "delete", "*"],
  "User" => ["create", "read", "update", "delete", "*"],
  "Comment" => ["read", "update", "delete", "create", "*"],
  "Role" => ["create", "read", "update", "delete", "grant", "*"],
  "WebConfig" => ["advanced_setting", "read", "update", "*"],
}

permissions.each do |grant_on, actions|
  actions.each do |action|
    next if Permission.where(name: action, granted_on: grant_on).exists?

    Permission.create!(name: action, granted_on: grant_on)
  end
end

roles = [
  { name: "Admin", protected: true },
  { name: "Editor" }
]

roles.each do |role|
  next if Role.where(name: role[:name]).exists?

  Role.create!(role)
end

# Grant all permission to Role
GrantedPermission.find_or_create_by!(permission_id: Permission.find_by!(granted_on: "*").id, granted_to: Role.find_by!(name: "Admin"))

editor_role = Role.find_by!(name: "Editor")
(permissions.keys - ["*", "Role", "User"]).each do |resource|
  GrantedPermission.find_or_create_by!(permission_id: Permission.find_by!(granted_on: resource, name: "*").id, granted_to: editor_role)
end
