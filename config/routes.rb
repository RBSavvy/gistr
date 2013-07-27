Gistr::Application.routes.draw do

  resources :gists

  root 'main#index'
end
