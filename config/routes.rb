Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # NOTE: Based on the wording of the task, I'm assuming we want a lookup based on :identifier rather than :id
      resources :locations, only: %w[show destroy create], param: :identifier, constraints: { identifier: /[0-z.-]+/ }
    end
  end
end
