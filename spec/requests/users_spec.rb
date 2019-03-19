# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users', type: :request do
  let(:role) { create :role, name: 'admin' }
  let(:admin_user) { create :user, email: 'admin@mail.com', password: '12345678', role_id: role.id }
  let(:user) { create :user, email: 'user@mail.com', password: '12345678' }
  let(:other_user) { create :user }

  let(:headers_admin) do
    { 'Authorization' => admin_user.generate_jwt_token }
  end

  let(:headers) do
    { 'Authorization' => user.generate_jwt_token }
  end

  describe 'GET /api/v1/users' do
    let!(:users) { create_list :user, 5 }

    it 'responds successfully' do
      get '/api/v1/users', headers: headers
      expect(response).to be_successful
    end

    it 'returns users collection' do
      get '/api/v1/users', headers: headers
      expect(json_body[:data].count).to eq(6)
    end
  end

  describe 'GET /api/v1/users/:id' do
    it 'responds successfully' do
      get "/api/v1/users/#{other_user.id}", headers: headers
      expect(response).to be_successful
    end

    it 'returns user by id' do
      get "/api/v1/users/#{other_user.id}", headers: headers
      expect(json_body[:data][:id]).to eq(other_user.id)
    end
  end

  describe 'GET /api/v1/users/current' do
    it 'responds successfully' do
      get '/api/v1/users/current', headers: headers
      expect(response).to be_successful
    end

    it 'returns current user' do
      get "/api/v1/users/current", headers: headers
      expect(json_body[:data][:id]).to eq(user.id)
    end
  end

  describe 'POST /api/v1/users' do
    let(:user_params) do
      {
        email: 'some@mail.com',
        first_name: 'first',
        last_name: 'last',
        password: '123123321'
      }
    end

    let(:without_email) do
      {
        first_name: 'first',
        last_name: 'last',
        password: '123123321'
      }
    end

    it 'responds successfully' do
      post '/api/v1/users', headers: headers_admin, params: user_params
      expect(response).to be_successful
    end

    it 'responds forbidden' do
      post '/api/v1/users', headers: headers, params: user_params
      expect(response).to be_forbidden
    end

    it 'creates user' do
      admin_user
      expect do
        post '/api/v1/users', headers: headers_admin, params: user_params
      end.to change { User.count }.from(1).to(2)
    end

    it 'return 400 if email does not exist' do
      post '/api/v1/users', headers: headers_admin, params: without_email
      expect(response.status).to eq(400)
    end
  end

  describe 'PUT /api/v1/users/:id' do
    let(:user_params) do
      {
        first_name: 'other first name'
      }
    end

    it 'responds successfully' do
      put "/api/v1/users/#{user.id}", headers: headers_admin, params: user_params
      expect(response).to be_successful
    end

    it 'responds forbidden' do
      put "/api/v1/users/#{admin_user.id}", headers: headers, params: user_params
      expect(response).to be_forbidden
    end

    it 'updates user' do
      put "/api/v1/users/#{user.id}", headers: headers_admin, params: user_params
      expect(user.reload.first_name).to eq('other first name')
    end
  end

  describe 'PUT /api/v1/users/:id/password' do
    let(:valid_params) do
      { old_password: '12345678', password: 'other_pass' }
    end

    let(:wrong_password) do
      { old_password: '321321321', password: 'other_pass' }
    end

    let(:no_password) do
      { password: 'other_pass' }
    end

    it 'responds successfully' do
      put "/api/v1/users/#{user.id}/password", headers: headers, params: valid_params
      expect(response).to be_successful
    end

    it 'responds forbidden if other user' do
      put "/api/v1/users/#{other_user.id}/password", headers: headers, params: valid_params
      expect(response).to be_forbidden
    end

    it 'responds forbidden if wrong password' do
      put "/api/v1/users/#{user.id}/password", headers: headers, params: wrong_password
      expect(response).to be_forbidden
    end

    it 'responds forbidden if no password' do
      put "/api/v1/users/#{user.id}/password", headers: headers, params: no_password
      expect(response).to be_forbidden
    end

    it 'updates user password' do
      put "/api/v1/users/#{user.id}/password", headers: headers, params: { old_password: '12345678', password: 'other_pass' }
      expect(user.reload.authenticate('other_pass')).to be_truthy
    end
  end

  describe 'DELETE /api/v1/users/:id' do
    it 'responds successfully' do
      delete "/api/v1/users/#{other_user.id}", headers: headers_admin
      expect(response).to be_successful
    end

    it 'responds forbidden' do
      delete "/api/v1/users/#{admin_user.id}", headers: headers
      expect(response).to be_forbidden
    end

    it 'deletes user' do
      other_user
      admin_user
      expect do
        delete "/api/v1/users/#{other_user.id}", headers: headers_admin
      end.to change { User.count }.from(2).to(1)
    end
  end
end
