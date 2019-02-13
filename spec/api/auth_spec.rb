require 'rails_helper'

RSpec.describe API, type: :request do
  let!(:user) { create :user, username: 'username', password: '12345678' }

  let(:headers) do
    { 'Authorization' => user.generate_jwt_token }
  end

  describe 'POST /api/v1/login' do
    it 'responds successfully' do
      post '/api/v1/login', params: { username: 'username', password: '12345678' }
      expect(response).to be_success
    end

    it 'returns jwt token' do
      post '/api/v1/login', params: { username: 'username', password: '12345678' }
      byebug
      expect_json_types token: :string
    end

    it 'returns 400 if invalid password' do
      post '/api/v1/login', params: { username: 'username', password: '1234567' }
      byebug
      expect(response.status).to eq(400)
    end
  end

  describe 'DELETE /api/v1/logout' do
    it 'responds successfully' do
      delete '/api/v1/logout', headers: headers
      expect(response).to be_success
    end

    it 'creates blacklist' do
      expect do
        delete '/api/v1/logout', headers: headers
      end.to change { JwtBlacklist.count }.from(0).to(1)
    end

    it 'blacklist assigned with current user' do
      delete '/api/v1/logout', headers: headers
      expect(JwtBlacklist.last.user_id).to eq(user.id)
    end

    it 'returns 401 if request without headers' do
      delete '/api/v1/logout'
      expect(response.status).to eq(401)
    end
  end
end