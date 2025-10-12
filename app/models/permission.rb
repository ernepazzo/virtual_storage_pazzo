# == Schema Information
#
# Table name: permissions
#
#  id              :bigint           not null, primary key
#  name            :string(255)
#  permission_type :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Permission < ApplicationRecord
  has_many :accesses, dependent: :destroy, inverse_of: :permission
end
