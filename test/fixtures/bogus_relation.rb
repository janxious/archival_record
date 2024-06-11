class BogusRelation < ApplicationRecord

  archival_record
  has_many :bogus_relations, dependent: :destroy

end
