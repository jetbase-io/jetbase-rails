require 'rails_helper'

RSpec.describe 'users', type: :request do
  let!(:user) { create :user, username: 'username', password: '12345678' }
  let(:other_user) { create :user }
  let(:headers) do
    { 'Authorization' => user.generate_jwt_token }
  end

  describe 'GET /users' do
    let!(:users) { create_list :user, 5 }

    it 'responds successfully' do
      get '/users', headers: headers
      expect(response).to be_successful
    end

    it 'returns users collection' do
      get '/users', headers: headers
      expect(json_body[:results].count).to eq(6)
    end
  end

  describe 'GET /users/:id' do
    it 'responds successfully' do
      get "/users/#{other_user.id}", headers: headers
      expect(response).to be_successful
    end

    it 'returns user by id' do
      get "/users/#{other_user.id}", headers: headers
      expect(json_body[:result][:id]).to eq(other_user.id)
    end
  end

  describe 'GET /users/current' do
    it 'responds successfully' do
      get '/users/current', headers: headers
      expect(response).to be_successful
    end

    it 'returns current user' do
      get "/users/current", headers: headers
      expect(json_body[:result][:id]).to eq(user.id)
    end
  end

  describe 'POST /users' do
    let(:user_params) do
      {
        username: 'someusername',
        email: 'some@mail.com',
        first_name: 'first',
        last_name: 'last',
        user_status: 'status',
        password: '123123321'
      }
    end

    it 'responds successfully' do
      post '/users', headers: headers, params: user_params
      expect(response).to be_successful
    end

    it 'creates user' do
      expect do
        post '/users', headers: headers, params: user_params
      end.to change { User.count }.from(1).to(2)
    end
  end

  describe 'PUT /users/:id' do
    let(:user_params) do
      {
        first_name: 'other first name'
      }
    end
    it 'responds successfully' do
      put "/users/#{user.id}", headers: headers, params: user_params
      expect(response).to be_successful
    end

    it 'updates user' do
      put "/users/#{user.id}", headers: headers, params: user_params
      expect(user.reload.first_name).to eq('other first name')
    end
  end

  describe 'PUT /users/:id/password' do
    it 'responds successfully' do
      put "/users/#{user.id}/password", headers: headers, params: { password: 'other_pass' }
      expect(response).to be_successful
    end

    it 'updates user password' do
      put "/users/#{user.id}/password", headers: headers, params: { password: 'other_pass' }
      expect(user.reload.authenticate('other_pass')).to be_truthy
    end
  end

  describe 'DELETE /users/:id' do
    it 'responds successfully' do
      delete "/users/#{other_user.id}", headers: headers
      expect(response).to be_successful
    end

    it 'deletes user' do
      other_user
      expect do
        delete "/users/#{other_user.id}", headers: headers
      end.to change { User.count }.from(2).to(1)
    end
  end
end
