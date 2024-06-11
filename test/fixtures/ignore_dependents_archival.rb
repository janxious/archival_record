# archive_number - string
# archived_at    - datetime
class IgnoreDependentsArchival < ActiveRecord::Base

  archival_record archive_dependents: false

  has_many :ignorable_dependents, dependent: :destroy

end
