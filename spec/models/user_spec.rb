require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to respond_to :username, :first_name, :last_name, :email, :user_status }
end
