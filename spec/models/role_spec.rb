# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role, type: :model do
  it { is_expected.to respond_to :name }
end
