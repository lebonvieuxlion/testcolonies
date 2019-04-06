Rails.application.routes.draw do

	resources :stays, only:[:show, :index]
	root 'stays#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
