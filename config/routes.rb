Rails.application.routes.draw do
  root 'stories#show'

  get 'stories/show'
  post 'stories/create'
end
