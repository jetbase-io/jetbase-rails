require 'rails_helper'

RSpec.describe 'auth', type: :request do
  let(:user) { create :user, email: 'user@mail.com', password: '12345678' }

  let(:headers) do
    { 'Authorization' => user.generate_jwt_token }
  end

  describe 'POST /api/v1/login' do
    let(:valid_params) do
      { email: 'user@mail.com', password: '12345678' }
    end

    let(:wrong_email) do
      { email: 'other_user@mail.com', password: '12345678' }
    end

    let(:wrong_password) do
      { email: 'user@mail.com', password: '1234567' }
    end

    before do
      user
    end

    it 'responds successfully' do
      post '/api/v1/login', params: valid_params
      expect(response).to be_successful
    end

    it 'returns jwt token' do
      post '/api/v1/login', params: valid_params
      expect_json_types token: :string
    end

    it 'returns 400 if wrong password' do
      post '/api/v1/login', params: wrong_password
      expect(response.status).to eq(400)
    end

    it 'returns 400 if wrong email' do
      post '/api/v1/login', params: wrong_email
      expect(response.status).to eq(400)
    end
  end

  describe 'DELETE /api/v1/logout' do
    it 'responds successfully' do
      delete '/api/v1/logout', headers: headers
      expect(response).to be_successful
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

    it 'returns 401 after logout' do
      delete '/api/v1/logout', headers: headers
      get "/api/v1/users/#{user.id}", headers: headers
      expect(response.status).to eq(401)
    end
  end
end