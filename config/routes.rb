Rails.application.routes.draw do
  root 'static_pages#home'

  post 'stories/create'
end
