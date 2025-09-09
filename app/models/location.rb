class Location < ApplicationRecord
  validates :identifier, uniqueness: true, presence: true

  # API client through dependency injection for flexibility.
  # Client should just implement `.search` and return {longitude:, latitude:} in response
  def update_geolocation!(client: IpstackClient)
    # OPTIMIZE: realistically, if certain identifiers are hit a lot more than others,
    # we should implement with Redis a hot cache with expiration in e.g. 1 day, or whatever seems reasonable
    #
    data = client.search(term: identifier)
    update!(lonlat: "POINT(#{data.fetch(:longitude)} #{data.fetch(:latitude)})", status: :updated)
    # OPTIMIZE: alternatively, in high scale I want to assign to async background job rather than a blocking sync operation e.g.:
    # AddGeolocationWorker.perform_async(identifier)
    #
    # class AddGeolocationWorker
    #   include Sidekiq::Worker
    #
    #   def perform(identifier)
    #     data = client.search(term: identifier)
    #     ...
    #   end
    # end
    #
    # We could also use a worker to batch them (e.g. every 100 identifiers) to save on requests
  end
end
