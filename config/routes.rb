Rails.application.routes.draw do
  get 'welcome/index'
  get '/dockers/images', to: 'dockers#get_dh_images' 
  get 'dockers/list'
  get '/dockers/schedule-test', to: 'dockers#schedule_test'
  get 'tests/schedule', to: 'tests#schedule'
  root 'welcome#index'
  resources :runningtests
  resources :dockers
  resources :tests
  resources :influxdbs
 # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
