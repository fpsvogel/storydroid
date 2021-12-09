Rails.application.routes.draw do
  root 'stories#show', as: :stories_show

  post 'stories/create'
end
