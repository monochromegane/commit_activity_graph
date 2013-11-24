CommitActivityGraph::Application.routes.draw do
  resources :commit_activity, only: [:index]
end
