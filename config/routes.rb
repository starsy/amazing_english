Rails.application.routes.draw do

  root to: 'users#index'

  resources :users
  resources :user_sessions

  get 'login' => 'user_sessions#new', :as => :login
  post '/user_sessions/new' => 'user_sessions#create'
  post 'logout' => 'user_sessions#destroy', :as => :logout
  get 'logout' => 'user_sessions#destroy'

  #root to: redirect('/events')

  resources :events do
    member do
      get 'answers' => 'answers#show'
      get 'answers/new' => 'answers#new'
      get 'answers/:answer_id' => 'answers#show_answer'
      get 'answers/:answer_id/edit' => 'answers#edit'
      patch 'answers/:answer_id' => 'answers#update'
      delete 'answers/:answer_id' => 'answers#destroy'

      get 'solutions' => 'solutions#show'
      get 'solutions/new' => 'solutions#new'
      get 'solutions/:solution_id' => 'solutions#show_solution'
      get 'solutions/:solution_id/edit' => 'solutions#edit'
      patch 'solutions/:solution_id' => 'solutions#update'
      delete 'solutions/:solution_id' => 'solutions#destroy'
    end

    resource :solutions
    resource :answers
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
