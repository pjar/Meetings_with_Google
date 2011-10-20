require 'spec_helper'

describe GoogleSynchronization do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: google_synchronizations
#
#  id             :integer         not null, primary key
#  object_id      :integer
#  attribute_name :string(255)
#  old_value      :text
#  new_value      :text
#  deleted        :boolean         default(FALSE)
#  created_at     :datetime
#  updated_at     :datetime
#

