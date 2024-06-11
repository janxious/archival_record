require_relative "test_helper"

class BogusRelationTest < ActiveSupport::TestCase

  test "does not successfully archive" do
    archival = BogusRelation.create!
    stub(ActiveRecord::Base.logger).error(
      satisfy do |arg|
        if arg.is_a?(String)
          arg == "SQLite3::SQLException: no such column: bogus_relations.bogus_relation_id"
        elsif arg.is_a?(Array)
          arg.join.match?(%r{gems/activerecord}) # this is gonna be in the stack trace somewhere
        else
          raise "unexpected logging"
        end
      end
    )
    assert_not archival.archive!
    assert_not archival.reload.archived?
  end

end
