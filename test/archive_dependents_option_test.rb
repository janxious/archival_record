require_relative "test_helper"

class ArchiveDependentsOptionTest < ActiveSupport::TestCase

  test "archive_dependents option will leave dependent archival records alone when parent is archived" do
    archival = IgnoreDependentsArchival.create!
    child = archival.ignorable_dependents.create!

    assert archival.archival?
    assert child.archival?

    archival.archive!

    assert archival.reload.archived?
    assert_not child.reload.archived?
  end

  test "archive_dependents option will leave dependent archival records alone when parent is unarchived" do
    archival = IgnoreDependentsArchival.create!
    child = archival.ignorable_dependents.create!

    assert archival.archival?
    assert child.archival?

    # This is simulating an unlikely scenario where the option has been added after records have been
    # archived as a set but we want to unarchive after adding the option.
    archival.archive!
    child.update!(archived_at: archival.archived_at, archive_number: archival.archive_number)

    archival.unarchive!

    assert_not archival.reload.archived?
    assert child.reload.archived?
  end

  test "archive_dependents option will work normally if set to true" do
    archival = ExplicitActOnDependentsArchival.create!
    child = archival.nonignorable_dependents.create!

    assert archival.archival?
    assert child.archival?

    archival.archive!

    assert archival.reload.archived?
    assert child.reload.archived?

    archival.unarchive!

    assert_not archival.reload.archived?
    assert_not child.reload.archived?
  end

end
