require 'rails_helper'

RSpec.describe 'auth', type: :request do
  let!(:user) { create :user, email: 'user@mail.com', password: '12345678' }

  let(:headers) do
    { 'Authorization' => user.generate_jwt_token }
  end

  describe 'POST /login' do
    it 'responds successfully' do
      post '/login', params: { email: 'user@mail.com', password: '12345678' }
      expect(response).to be_successful
    end

    it 'returns jwt token' do
      post '/login', params: { email: 'user@mail.com', password: '12345678' }
      expect_json_types token: :string
    end

    it 'returns 400 if invalid password' do
      post '/login', params: { email: 'user@mail.com', password: '1234567' }
      expect(response.status).to eq(400)
    end
  end

  describe 'DELETE /logout' do
    it 'responds successfully' do
      delete '/logout', headers: headers
      expect(response).to be_successful
    end

    it 'creates blacklist' do
      expect do
        delete '/logout', headers: headers
      end.to change { JwtBlacklist.count }.from(0).to(1)
    end

    it 'blacklist assigned with current user' do
      delete '/logout', headers: headers
      expect(JwtBlacklist.last.user_id).to eq(user.id)
    end

    it 'returns 401 if request without headers' do
      delete '/logout'
      expect(response.status).to eq(401)
    end
  end
end