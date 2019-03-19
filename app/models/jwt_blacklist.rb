# frozen_string_literal: true

class JwtBlacklist < ApplicationRecord
  belongs_to :user
end
