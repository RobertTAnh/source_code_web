# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

theme = Theme.create!(name: 'Default theme', source: 'local', path: 'demo', is_default: true)

View.create!([
  { code: 'home', name: 'Home', template_format: 'text', template: 'This is home', theme: theme },
  { code: 'page1', name: 'Page 1', template_format: 'text', template: 'This is page 1', theme: theme },
  { code: 'page2', name: 'Page 2', template_format: 'text', template: 'This is page 2', theme: theme },
  { code: 'category', name: 'Category', template_format: 'text', template: 'This is a category', theme: theme },
])

Page.create!([
  { slug: '/', name: 'Home', view:  View.find_by(code: 'home') },
  { slug: 'page1', name: 'Page 1', view: View.find_by(code: 'page1') },
  { slug: 'page2', name: 'Page 2', view: View.find_by(code: 'page2') },
  { slug: 'about', name: 'About' },

])

Product.create!([
  { slug: 'product_1', name: 'Product 1' },
])

Category.create!([
  { slug: 'category_1', name: 'Category 1', depth: 1, view: View.find_by(code: 'category') },
  { slug: 'category_2', name: 'Category 2', depth: 1, view: View.find_by(code: 'category') },
])
