Rails.application.routes.draw do
  get   'index', to: 'pages#index'  
  post  'index', to: 'pages#index'  
  get   'detail', to: 'pages#detail'    
  get   'near_by', to: 'pages#near_by'  
  get   'near_by_detail', to: 'pages#near_by_detail'      

  get   'search_by_keyword', to: 'pages#search_by_keyword_json'  
  get   'search_by_place_id', to: 'pages#search_by_place_id_json'    
  get   'get_place_id', to: 'pages#get_place_id_json'      
  get   'get_detail', to: 'pages#get_detail_json'    

  root :to => 'pages#index'
end
