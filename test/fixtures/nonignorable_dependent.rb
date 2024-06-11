# explicit_act_on_dependents_archival_id - integer
# archive_number                         - string
# archived_at                            - datetime
class NonignorableDependent < ActiveRecord::Base

  archival_record

  belongs_to :explicit_act_on_dependents_archival

end
