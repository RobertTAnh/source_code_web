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
end
