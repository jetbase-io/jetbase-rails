class Role < ApplicationRecord
  has_many :role_permissions
  has_many :permissions, through: :role_permissions

  def permissions_names
    permissions.map(&:name)
  end
end
