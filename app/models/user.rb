# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  deleted_at             :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  failed_attempts        :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string(255)
#  unlock_token           :string(255)
#  whatsapp               :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role_id                :bigint
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_deleted_at            (deleted_at)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_role_id               (role_id)
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (role_id => roles.id)
#
class User < ApplicationRecord
  include Imagen
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  acts_as_paranoid
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  # validates :whatsapp, resence: false, uniqueness: true,
  #           format: {
  #             # with: /\A\+[0-9]+\z/,
  #             with: /\A[0-9]+\z/,
  #             message: :invalid
  #           }

  has_many :products, dependent: :destroy
  has_many :favorites, dependent: :destroy

  belongs_to :role
  attr_accessor :permissions

  validate :role_priority_cannot_decrease, on: :update

  def access_and_permissions
    role_access = RoleHasAccess.where(role_id: role&.id)
    access_permissions = {}
    if role_access.count > 0
      role_access.each do |ra|
        if ra.access.can_show || ra.access.can_create || ra.access.can_edit || ra.access.can_delete || ra.access.can_other
          access_permissions[ra.access.permission.permission_type] = {
            show: ra.access.can_show,
            create: ra.access.can_create,
            edit: ra.access.can_edit,
            delete: ra.access.can_delete,
            other: ra.access.can_other,
          }
        end
      end
    end

    access_permissions
  end

  private

  def role_priority_cannot_decrease
    return unless role_id_changed?

    current_role_priority = role_id_was || 0
    new_role_priority = Role.find_by(id: role_id)&.priority || 0

    if new_role_priority < current_role_priority
      errors.add(:role, "no puede tener menor prioridad que el rol actual")
    end
  end
end
