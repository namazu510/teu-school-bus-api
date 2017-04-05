Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # api path
  get 'api/v1/next', :to => 'api#next'
  get 'api/v1/schedule_by_day', :to => 'api#schedule_by_day'
end
