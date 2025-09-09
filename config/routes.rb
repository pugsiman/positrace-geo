Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # NOTE: Based on the wording of the task, I'm assuming we want a lookup based on :identifier rather than :id
      # A given IP address and URL may disattach, and a physical location association with an IP address may change.
      # Using IP/URL as identifiers enables us to use a hybrid approach where we avoid accumulating stale data
      resources :locations, only: %w[show destroy create], param: :identifier, constraints: { identifier: /[0-z.-]+/ }
    end
  end
end
