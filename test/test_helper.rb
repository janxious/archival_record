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

BASE_FIXTURE_CLASSES = %I[
  another_polys_holder
  archival
  archival_kid
  archival_grandkid
  archival_table_name
  exploder
  independent_archival
  missing_archived_at
  missing_archive_number
  plain
  poly
  readonly_when_archived
  deprecated_warning_archival
  ignore_dependents_archival
  ignorable_dependent
  explicit_act_on_dependents_archival
  nonignorable_dependent
].freeze

RAILS_4_FIXTURE_CLASSES = %I[
  callback_archival4
].freeze

RAILS_5_FIXTURE_CLASSES = %I[
  application_record
  application_record_row
  callback_archival5
].freeze

def require_test_classes
  ActiveSupport::Inflector.inflections do |inflect|
    inflect.irregular "poly", "polys"
  end

  fixtures = if ActiveRecord::VERSION::MAJOR >= 4
               RAILS_5_FIXTURE_CLASSES
             else
               RAILS_4_FIXTURE_CLASSES
             end

  fixtures += BASE_FIXTURE_CLASSES
  fixtures.each { |test_class_file| require_relative "fixtures/#{test_class_file}" }
end

prepare_for_tests
