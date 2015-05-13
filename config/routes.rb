Rails.application.routes.draw do
  #resources :answers
  #resources :solutions

  resources :events do
    member do
      get 'answers' => 'answers#show_event_answers'
      get 'answers/new' => 'answers#new'
      get 'answers/:answer_id' => 'answers#show'
      get 'answers/:answer_id/edit' => 'answers#edit_event_answer'
      patch 'answers/:answer_id' => 'answers#update_event_answer'

      get 'solutions' => 'solutions#show_event_solutions'
      get 'solutions/new' => 'solutions#new'
      get 'solutions/:solution_id' => 'solutions#show'
      get 'solutions/:solution_id/edit' => 'solutions#edit_event_solution'
      patch 'solutions/:solution_id' => 'solutions#update_event_solution'
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