pages = [
  { name: 'Home', slug:'/' },
]

pages.each do |page|
  next if Page.where(slug: page[:slug]).exists?

  Page.create!(page.merge(status: 'published'))
end
