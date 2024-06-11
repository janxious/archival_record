$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../lib")

require "bundler/setup"
require "minitest/autorun"
require "minitest/pride"

require "active_record"
require "database_cleaner"

require "archival_record"

ActiveSupport::TestCase.test_order = :random if ActiveSupport::TestCase.respond_to?(:test_order=)

def prepare_for_tests
  setup_logging
  setup_database_cleaner
  create_test_tables
  require_test_classes
end

def setup_logging
  require "logger"
  logfile = "#{File.dirname(__FILE__)}/debug.log"
  ActiveRecord::Base.logger = Logger.new(logfile)
end

def setup_database_cleaner
  DatabaseCleaner.strategy = :truncation
  ActiveSupport::TestCase.send(:setup) do
    DatabaseCleaner.clean
  end
end

def sqlite_config
  {
    adapter: "sqlite3",
    database: "archival_record_test.sqlite3",
    pool: 5,
    timeout: 5000
  }
end

def schema_file
  "#{File.dirname(__FILE__)}/schema.rb"
end

def create_test_tables
  puts "** Loading schema for SQLite"
  ActiveRecord::Base.establish_connection(sqlite_config)
  load(schema_file) if File.exist?(schema_file)
end

FIXTURE_CLASSES = %I[
  another_polys_holder
  application_record
  application_record_row
  archival
  archival_grandkid
  archival_kid
  archival_table_name
  bogus_relation
  callback_archival
  deprecated_warning_archival
  explicit_act_on_dependents_archival
  exploder
  ignorable_dependent
  ignore_dependents_archival
  independent_archival
  missing_archive_number
  missing_archived_at
  nonignorable_dependent
  plain
  poly
  readonly_when_archived
].freeze

def require_test_classes
  ActiveSupport::Inflector.inflections do |inflect|
    inflect.irregular "poly", "polys"
  end

  FIXTURE_CLASSES.each { |test_class_file| require_relative "fixtures/#{test_class_file}" }
end

prepare_for_tests
