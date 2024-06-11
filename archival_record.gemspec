$LOAD_PATH.push File.expand_path("lib", __dir__)

require "archival_record/version"

Gem::Specification.new do |gem|
  gem.name     = "archival_record"
  gem.summary  = "Atomic archiving/unarchiving for ActiveRecord"
  gem.version  = ArchivalRecord::VERSION
  gem.authors  = ["Joel Meador",
                  "Michael Kuehl",
                  "Matthew Gordon",
                  "Vojtech Salbaba",
                  "David Jones",
                  "Dave Woodward",
                  "Miles Sterrett",
                  "James Hill",
                  "Maarten Claes",
                  "Anthony Panozzo",
                  "Aaron Milam",
                  "Anton Rieder",
                  "Josh Menden",
                  "Sergey Gnuskov",
                  "Elijah Miller"]
  gem.email    = ["joel.meador+archival_record@gmail.com"]
  gem.homepage = "https://gitlab.com/joelmeador/archival_record/"
  gem.licenses = ['MIT']

  gem.files = `git ls-files`.split("\n")
  gem.require_paths = ["lib"]
  gem.required_ruby_version = ">= 3.0"

  gem.add_dependency("activerecord", ">= 6.0")

  # rubocop:disable Gemspec/DevelopmentDependencies
  gem.add_development_dependency("appraisal")
  gem.add_development_dependency("database_cleaner")
  gem.add_development_dependency("rake")
  gem.add_development_dependency("rr")
  gem.add_development_dependency("rubocop")
  gem.add_development_dependency("rubocop-rails")
  gem.add_development_dependency("rubocop-rake")
  gem.add_development_dependency("sqlite3", "< 2")
  # rubocop:enable Gemspec/DevelopmentDependencies

  gem.description =
    <<~DESCRIPTION
      *Atomic archiving/unarchiving for ActiveRecord*

      acts_as_paranoid and similar plugins/gems work on a record-by-record basis and make it difficult to restore records atomically (or archive them, for that matter).

      Because ArchivalRecord's #archive! and #unarchive! methods are in transactions, and every archival record involved gets the same archive number upon archiving, you can easily restore or remove an entire set of records without having to worry about partial deletion or restoration.

      Additionally, other plugins generally change how destroy/delete work. ArchivalRecord does not, and thus one can destroy records like normal.
    DESCRIPTION
  gem.metadata["rubygems_mfa_required"] = "true"
end
