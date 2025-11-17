require_relative "lib/admin/version"

Gem::Specification.new do |spec|
  spec.name        = "admin"
  spec.version     = Admin::VERSION
  spec.authors     = ["Hai Le"]
  spec.email       = ["tech@fagogroup.com"]
  spec.homepage    = "https://fagotech.vn"
  spec.summary     = "Admin page"
  spec.description = "Admin page"
  
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "http://mygemserver.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://gitlab.com/fagotech/waker"
  spec.metadata["changelog_uri"] = "https://gitlab.com/fagotech/waker"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.3"
end
