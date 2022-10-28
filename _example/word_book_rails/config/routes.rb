Rails.application.routes.draw do
  get 'words/index'
  get 'words/show/:id', to: "words#show"
  get 'words/append'
  post 'words/create'
  get 'words/change'
  post 'words/update'
  get 'words/delete'
  delete 'words/exec_delete'
  get 'words/search'
  get 'words/list'
  root "words#index"
end
