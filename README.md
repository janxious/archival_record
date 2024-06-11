# ArchivalRecord

Atomically archive object trees in your ActiveRecord models.

`acts_as_paranoid` and similar plugins/gems work on a record-by-record basis and made it difficult to restore records atomically (or archive them, for that matter).

Because the `#archive!` and `#unarchive!` methods are in transactions, and every archival record involved gets the same archive number upon archiving, you can easily restore or remove an entire set of records without having to worry about partial deletion or restoration.

Additionally, other plugins generally change how `destroy`/`delete` work. ArchivalRecord does not, and thus one can destroy records like normal.

_This is a fork of [ActsAsArchival](https://github.com/expectedbehavior/acts_as_archival/)._

## Maintenance

You might read the commit logs and think "This must be abandonware! This hasn't been updated in 2y!" But! This is a mature project that solves a specific problem in ActiveRecord. It tends to only be updated when a new major version of ActiveRecord comes out and hence the infrequent updates.

## Install

Gemfile:

`gem "archival_record"`

Any models you want to be archival should have the columns `archive_number` (`String`) and `archived_at` (`DateTime`).

i.e. `rails g migration AddArchivalRecordToPost archive_number archived_at:datetime`

Any dependent-destroy ArchivalRecord model associated to an ArchivalRecord model will be archived with its parent.

_If you're stuck on Rails 5x/4x/3x/2x, check out the older tags/branches, which are no longer in active development._

## Example

``` ruby
class Hole < ApplicationRecord
  archival_record
  has_many :rats, dependent: :destroy
end

class Rat < ApplicationRecord
  archival_record
end
```

### Simple interactions & scopes

``` ruby
h = Hole.create                  #
h.archived?                      # => false
h.archive!                       # => true
h.archived?                      # => true
h.archive_number                 # => "b56876de48a5dcfe71b2c13eec15e4a2"
h.archived_at                    # => Thu, 01 Jan 2012 01:49:21 -0400
h.unarchive!                     # => true
h.archived?                      # => false
h.archive_number                 # => nil
h.archived_at                    # => nil
```

### Associations

``` ruby
h = Hole.create                  #
r = h.rats.create                #
h.archive!                       # => true
h.archive_number                 # => "b56876de48a5dcfe71b2c13eec15e4a2"
r.archived_at                    # => Thu, 01 Jan 2012 01:52:12 -0400
r.archived?                      # => true
h.unarchive!                     # => true
h.archive_number                 # => nil
r.archived_at                    # => nil
r.archived?                      # => false
```

### Relations

```ruby
Hole.create!
Hole.create!
Hole.create!

holes = Hole.all

# All records in the relation will be archived with the same archive_number.
# Dependent/Destroy relationships will be archived, and callbacks will still be honored.
holes.archive_all!              # => [array of Hole records in the relation]

holes.first.archive_number      # => "b56876de48a5dcfe71b2c13eec15e4a2"
holes.last.archive_number       # => "b56876de48a5dcfe71b2c13eec15e4a2"

holes.unarchive_all!            # => [array of Hole records in the relation]
```

### Scopes

``` ruby
h = Hole.create
Hole.archived.size               # => 0
Hole.unarchived.size             # => 1
h.archive!
Hole.archived.size               # => 1
Hole.unarchived.size             # => 0
```

### Utility methods

``` ruby
h = Hole.create                  #
h.archival?                   # => true
Hole.archival?                # => true
```

### Options

#### `readonly_when_archived`
When defining an ArchivalRecord model, it is is possible to make it unmodifiable
when it is archived by passing `readonly_when_archived: true` to the
`archival_record` call in your model. The default value of this option is `false`.

``` ruby
class CantTouchThis < ApplicationRecord
  archival_record readonly_when_archived: true
end

record = CantTouchThis.create(foo: "bar")
record.archive!                              # => true
record.foo = "I want this to work"
record.save                                  # => false
record.errors.full_messages.first            # => "Cannot modify an archived record."
```

#### `archive_dependents`
When defining an ArchivalRecord model, it is possible to deactivate archiving/unarchiving for `dependent: :destroy` relationships that are tied to ArchivalRecord models by passing `archive_dependents: false` to the `archival_record` call in your model. The default value of this option is `true`.

``` ruby
class WillArchive < ApplicationRecord
  archival_record archive_dependents: false
  has_many :wont_archives, dependent: :destroy
end
class WontArchive < ApplicationRecord
  archival_record
end

record = WillArchive.create
wont_archive = record.wont_archives.create
record.archive!

record.archived?       # => true
wont_archive.archived? # => false
```

### Callbacks

ArchivalRecord models have four additional callbacks to do any necessary cleanup or other processing before and after archiving and unarchiving, and can additionally halt the archive callback chain.

``` ruby
class Hole < ApplicationRecord
  archival_record

  # runs before #archive!
  before_archive :some_method_before_archiving

  # runs after #archive!
  after_archive :some_method_after_archiving

  # runs before #unarchive!
  before_unarchive :some_method_before_unarchiving

  # runs after #unarchive!
  after_unarchive :some_method_after_unarchiving

  # ... implement those methods
end
```

#### Halting the callback chain

* Rails 6.x+ - the callback should `throw(:abort)`/`raise(:abort)`.

## Caveats

1. This will only work on associations that are marked `dependent: :destroy`. It should be trivial to change that or make it optional.
1. If you would like to work on this, you will need to setup sqlite on your development machine. Alternately, you can deactivate specific dev dependencies in the `gemspec` and `test_helper` or ask for help in an issue.

## Compatibility with ActsAsArchival

For now, the `acts_as_archival` class method can be used, though it will print a deprecation warning. This is to allow users to transition without trouble to this library if they choose to.

## Testing

Running the tests should be as easy as:

```  bash
script/setup                 # bundles, makes databases with permissions
rake                         # run tests on latest Rails
appraisal rake               # run tests on all versions of Rails
```

Check out [more on appraisal](https://github.com/thoughtbot/appraisal#usage) if you need to add new versions of things or run into a version bug.

## Help Wanted

I'd love to have your help making this better! If you have ideas for features this should implement or you think the code sucks, let us know. And PRs are greatly appreciated. :+1:

## Thanks

ActsAsParanoid and PermanentRecords were both inspirations for this:

* http://github.com/technoweenie/acts_as_paranoid
* http://github.com/fastestforward/permanent_records

## Contributors

* Joel Meador
* Aaron Milam
* Anthony Panozzo
* Anton Rieder
* Dave Woodward
* David Jones
* Elijah Miller
* James Hill
* Josh Menden
* Maarten Claes
* Matthew Gordon
* Michael Kuehl
* Miles Sterrett
* Sergey Gnuskov
* Vojtech Salbaba

Thanks!

[MIT-Licensed](LICENSE)
