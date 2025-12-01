user_ids = User.left_joins(:user_roles).where('user_roles.id is null').pluck :id

if user_ids.present? && admin_role = Role.find_by(name: 'Admin')
  user_ids.each do |user_id|
    UserRole.find_or_create_by!(user_id: user_id, role_id: admin_role.id)
  end
end
