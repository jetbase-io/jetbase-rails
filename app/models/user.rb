class User < ApplicationRecord
  has_secure_password

  has_many :user_permissions
  has_many :permissions, through: :user_permissions
  has_many :user_roles
  has_many :roles, through: :user_roles

  validates :email, presence: true, uniqueness: true

  def generate_jwt_token
    JwtAuth.issue(user_id: id)
  end

  def admin?
    roles.map(&:name).include?("admin")
  end

  def permissions_names
    (permissions.map(&:name) + roles.map(&:permissions_names).flatten).uniq
  end
end
