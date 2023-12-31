require_relative "lib/super_template/version"

Gem::Specification.new do |spec|
  spec.name        = "super_template"
  spec.version     = SuperTemplate::VERSION
  spec.authors     = ["Chongchen Chen"]
  spec.email       = ["chenkovsky@qq.com"]
  spec.homepage    = "https://github.com/chenkovsky/super_template"
  spec.summary     = "SQL Template for Ruby"
  spec.description = "SQL Template for Ruby"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "http://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/chenkovsky/super_template"
  spec.metadata["changelog_uri"] = "https://github.com/chenkovsky/super_template/CHANGELOG.md"

  spec.add_runtime_dependency "activesupport", ">= 7.0"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end
end
