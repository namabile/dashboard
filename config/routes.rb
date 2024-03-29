Dashboard::Application.routes.draw do
  root :to => "pages#home";
  match "30-day-visits" => "pages#visits", as: :visits
  match "year-over-year-comparison" => "pages#year_over_year", as: :yoy
  match "total-orders" => "pages#total_orders", as: :total_orders
  match "get-total-orders" => "pages#get_total_orders", as: :get_total_orders
  match "reports/event-ticket-report" => "reports#event_ticket_report", as: :event_ticket_report
  match "reports/run-event-ticket-report" => "reports#run_event_ticket_report", as: :run_event_ticket_report
  match "reports/export-to-excel" => "reports#export_to_excel", as: :export_to_excel
  match "reports/spiff-report" => "reports#spiff_report", as: :spiff_report
  match "reports/run-spiff-report" => "reports#run_spiff_report", as: :run_spiff_report


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
