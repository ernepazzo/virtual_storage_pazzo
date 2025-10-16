# == Schema Information
#
# Table name: roles
#
#  id           :bigint           not null, primary key
#  admin_access :boolean          default(FALSE)
#  is_default   :boolean          default(FALSE)
#  priority     :integer          default(1), not null
#  role_type    :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Role < ApplicationRecord
  has_many :role_has_accesses, dependent: :destroy
  has_many :accesses, through: :role_has_accesses
  has_many :users

  accepts_nested_attributes_for :accesses
  attr_accessor :accesses_attributes

  validates :role_type, presence: {
    message: lambda do |object, data|
      "El nombre del Rol no puede estar vacío."
    end
  }, uniqueness: {
    message: lambda do |object, data|
      "El nombre del Rol debe ser único."
    end
  }

  def save_access_for_roles(view = nil)
    if view&.include?('edit')
      roles_access_exist = RoleHasAccess.where(role_id: id)
      roles_access_exist.each(&:destroy) if roles_access_exist.count.positive?
    end

    accesses_attributes.each do |access|
      new_permision = Access.find_or_create_by(permission_id: access[1]['permissions_id'],
                                               can_show: access[1]['can_show'],
                                               can_create: access[1]['can_create'],
                                               can_edit: access[1]['can_edit'],
                                               can_delete: access[1]['can_delete'],
                                               can_other: access[1]['can_other'])

      RoleHasAccess.find_or_create_by(role_id: id, access_id: new_permision.id)
    end
  end

  def get_role_with_access_and_permissions
    description = "<table class='table table-bordered table-striped table-sm'>"
    accesses = RoleHasAccess.where(role_id: self)
    unless accesses.blank?
      accesses.each do |access|
        if access.access.can_show ||access.access.can_create || access.access.can_edit || access.access.can_delete|| access.access.can_other
          description += "<tr>"
          description += "<td>#{access.access.permission.name}</td>"
          description += "<td>Mostrar: #{access.access.can_show? ? '<span class="bi bi-check text-success"></span>' : '<span class="bi bi-x text-danger"></span>'}</td>"
          description += "<td>Crear: #{access.access.can_create? ? '<span class="bi bi-check text-success"></span>' : '<span class="bi bi-x text-danger"></span>'}</td>"
          description += "<td>Editar: #{access.access.can_edit? ? '<span class="bi bi-check text-success"></span>' : '<span class="bi bi-x text-danger"></span>'}</td>"
          description += "<td>Eliminar: #{access.access.can_delete? ? '<span class="bi bi-check text-success"></span>' : '<span class="bi bi-x text-danger"></span>'}</td>"
          description += "<td>Otras acciones: #{access.access.can_other ? '<span class="bi bi-check text-success"></span>' : '<span class="bi bi-x text-danger"></span>'}</td>"
          description += "</tr>"
        end
      end
    end
    description += "</table>"
  end
end
