Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/rank/:id', to: 'members#rank', as: 'rank'
  patch '/rank/:id', to: 'members#currentRank', as: 'rank_update'
  resources :members
end
