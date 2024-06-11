# archive_number                - string
# archived_at                   - datetime
class ExplicitActOnDependentsArchival < ActiveRecord::Base

  archival_record archive_dependents: true

  has_many :nonignorable_dependents, dependent: :destroy

end
