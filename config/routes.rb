Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :locations, only: %w[create]

      # NOTE: Based on the wording of the task, I'm assuming you wanted a lookup based on :identifier rather than :id
      resources :locations, only: %w[show destroy], param: :identifier, constraints: { identifier: /[0-z.-]+/ }
    end
  end
end
