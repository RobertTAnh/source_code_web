if (list = ENV['SEEDING_USERS']).present?
  list.split(';').each do |info|
    name, email = info.split(',').map(&:strip)

    puts "Name: #{name}. Email: #{email}"

    next if User.where(email: email).exists?

    User.create!(
      name: name,
      email: email,
      password: SecureRandom.hex
    )
  end

  role = Role.find_by!(name: "Admin")
  list.split(';').each do |info|
    name, email = info.split(',').map(&:strip)
    user = User.find_by!(email: email)
    user.user_roles.find_or_create_by!(role_id: role.id)
  end
end
