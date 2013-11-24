CommitActivityGraph::Application.routes.draw do
  get '/commit_activity(/since/:since)', to: 'commit_activity#index'
end
