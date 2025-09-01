require_relative "lib/kinesis_ui/version"

Gem::Specification.new do |spec|
  spec.name        = "kinesis_ui"
  spec.version     = KinesisUi::VERSION
  spec.authors     = [ "ViniciusLisboa07" ]
  spec.email       = [ "viniciuslisboa1001@gmail.com" ]
  spec.homepage    = "https://github.com/ViniciusLisboa07/kinesis_ui"
  spec.summary     = "Summary of KinesisUi."
  spec.description = "Description of KinesisUi."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata = {
    "homepage_uri"   => spec.homepage,
    "source_code_uri" => "https://github.com/ViniciusLisboa07/kinesis_ui",
    "changelog_uri"  => "https://github.com/ViniciusLisboa07/kinesis_ui/blob/main/CHANGELOG.md"
  }

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.2.2.1"
  spec.add_dependency "tailwindcss-rails"
end
