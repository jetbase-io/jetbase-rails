class User < ApplicationRecord
  has_secure_password

  def generate_jwt_token
    JwtAuth.issue({ user_id: id })
  end
end
