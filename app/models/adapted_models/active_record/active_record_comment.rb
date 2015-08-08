class ActiveRecordComment < ActiveRecord::Base
  include MongoidAdaptable

  self.table_name = "discourses"

  before_create do
    self.discourse_type = "comment"
  end
end