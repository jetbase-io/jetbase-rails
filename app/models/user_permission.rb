class UserPermission < ApplicationRecord
  belongs_to :permission
  belongs_to :user
end
