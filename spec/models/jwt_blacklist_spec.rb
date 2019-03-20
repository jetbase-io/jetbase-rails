require 'rails_helper'

RSpec.describe JwtBlacklist, type: :model do
  it { is_expected.to respond_to :token, :user_id }
end
