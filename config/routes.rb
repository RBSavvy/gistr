Gistr::Application.routes.draw do
  get 'gists/random' => 'gists#random'
  get 'gists/:language/random' => 'gists#random', as: "gist_with_lang"
  get 'gists/:id' => 'gists#show'

  root 'main#index'
end
