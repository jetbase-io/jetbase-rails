require 'rails_helper'

RSpec.describe API do
  let(:headers) do
    { 'Authorization' => 'some_token' }
  end

  describe 'GET /api/v1/users' do
    it 'responds successfully' do
      get '/api/v1/users', headers: headers
      expect(response).to be_success
    end

    it 'returns users collection'
  end

  describe 'GET /api/v1/users/:id' do
    it 'responds successfully' do
      get '/api/v1/users/:id', headers: headers
      expect(response).to be_success
    end

    it 'returns user by id'
  end

  describe 'GET /api/v1/users/current' do
    it 'responds successfully' do
      get '/api/v1/users/:name', headers: headers
      expect(response).to be_success
    end

    it 'returns user by name'
  end

  describe 'POST /api/v1/users' do
    it 'responds successfully' do
      post '/api/v1/users', headers: headers
      expect(response).to be_success
    end

    it 'creates user'
  end

  describe 'PUT /api/v1/users/:id' do
    it 'responds successfully' do
      put '/api/v1/users/:id', headers: headers
      expect(response).to be_success
    end

    it 'updates user'
  end

  describe 'PUT /api/v1/users/:id/password' do
    it 'responds successfully' do
      put '/api/v1/users/:id/password', headers: headers
      expect(response).to be_success
    end

    it 'updates user password'
  end

  describe 'DELETE /api/v1/users/:id' do
    it 'responds successfully' do
      delete '/api/v1/users/:id', headers: headers
      expect(response).to be_success
    end

    it 'deletes user'
  end
end
