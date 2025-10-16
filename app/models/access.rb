# == Schema Information
#
# Table name: accesses
#
#  id            :bigint           not null, primary key
#  can_create    :boolean          default(FALSE)
#  can_delete    :boolean          default(FALSE)
#  can_edit      :boolean          default(FALSE)
#  can_other     :boolean          default(FALSE)
#  can_show      :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  permission_id :bigint           not null
#
# Indexes
#
#  index_accesses_on_permission_id  (permission_id)
#
# Foreign Keys
#
#  fk_rails_...  (permission_id => permissions.id)
#
class Access < ApplicationRecord
  belongs_to :permission
end
