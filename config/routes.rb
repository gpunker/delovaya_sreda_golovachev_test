Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope '/api' do
    scope '/users' do
      get '/', to: 'users#index', as: 'users_index'
      get '/:id/operations', to: 'users#operations', as: 'user_operations'
    end
    scope '/operations' do
      post '/', to: 'operations#create', as: 'operations_create'
    end
  end
end
