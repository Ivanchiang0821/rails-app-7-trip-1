Rails.application.routes.draw do
  get   'index', to: 'pages#index'  
  get   'detail', to: 'pages#detail'    
  get   'nearby', to: 'pages#nearby'  
  post  'keyword', to: 'pages#keyword'      
  get   'keyword', to: 'pages#keyword'    
  get   'statistics', to:'pages#statistics'
  root :to => 'pages#index'
end
