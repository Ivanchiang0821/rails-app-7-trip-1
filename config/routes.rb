Rails.application.routes.draw do
  get   'index', to: 'pages#index'  
  post  'index', to: 'pages#index'  
  get   'detail', to: 'pages#detail'    
  get   'near_by', to: 'pages#near_by'  

  root :to => 'pages#index'
end
