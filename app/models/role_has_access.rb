# == Schema Information
#
# Table name: role_has_accesses
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  access_id  :bigint           not null
#  role_id    :bigint           not null
#
# Indexes
#
#  index_role_has_accesses_on_access_id  (access_id)
#  index_role_has_accesses_on_role_id    (role_id)
#
# Foreign Keys
#
#  fk_rails_...  (access_id => accesses.id)
#  fk_rails_...  (role_id => roles.id)
#
class RoleHasAccess < ApplicationRecord
  belongs_to :role
  belongs_to :access
end
