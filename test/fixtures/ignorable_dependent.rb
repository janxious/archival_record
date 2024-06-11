# ignore_dependents_archival_id - integer
# archive_number                - string
# archived_at                   - datetime
class IgnorableDependent < ActiveRecord::Base

  archival_record

  belongs_to :ignore_dependents_archival

end
