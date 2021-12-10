Rails.application.routes.draw do
  root 'stories#edit', as: :stories_edit

  patch 'stories/update'
end
