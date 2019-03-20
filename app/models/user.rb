class User < ApplicationRecord
  has_secure_password

  belongs_to :role, optional: true

  validates :email, presence: true, uniqueness: true

  def generate_jwt_token
    JwtAuth.issue(user_id: id)
  end

  def admin?
    role && role.name == 'admin'
  end

  def permissions
    if admin?
      [
        { action: :read, entities: 'User', can: true },
        { action: :create, entities: 'User', can: true },
        { action: :delete, entities: 'User', can: true },
        { action: :update, entities: 'User', can: true }
      ]
    else
      [
        { action: :read, entities: 'User', can: true },
        { action: :create, entities: 'User', cannot: true },
        { action: :delete, entities: 'User', cannot: true },
        { action: :update, entities: 'User', cannot: true }
      ]
    end
  end
end
