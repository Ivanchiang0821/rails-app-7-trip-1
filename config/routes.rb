Rails.application.routes.draw do
  get   'index', to: 'pages#index'  
  post  'index', to: 'pages#index'  
  get   'generate_json', to: 'pages#gen_json'  
  root :to => 'pages#index'
end
