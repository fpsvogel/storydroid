Rails.application.routes.draw do
  root 'stories#show'

  post 'stories/create'
end
