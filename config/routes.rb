Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope '/api' do
    scope '/users' do
      get '/', to: 'users#index', name: 'users_index'
      get '/:id/operations', to: 'users#operations', name: 'user_operations'
    end
  end
end
