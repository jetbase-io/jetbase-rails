Rails.application.routes.draw do
  scope 'api/v1' do
    post :login, to: 'auth#login'
    delete :logout, to: 'auth#logout'

    resources :users do
      get :current, to: 'users#current', on: :collection
      put :password, to: 'users#update_password', on: :member
    end
  end
end
