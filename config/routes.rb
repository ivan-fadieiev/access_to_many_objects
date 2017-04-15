Rails.application.routes.draw do
  get  'user/new_info', to: 'home#new_info',    as: 'new_info'
  post 'user',          to: 'home#create_info', as: 'create_user_info'
  get  'user/:id',      to: 'home#user_page',   as: 'user'
  put  'user/:id',      to: 'home#edit_info',   as: 'edit_user_info'
  root 'home#all_users'
end
