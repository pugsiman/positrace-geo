class Location < ApplicationRecord
  validates :identifier, uniqueness: true

  def add_geolocation!(client: IpstackClient)
    data = client.search(term: identifier)
    update!(lonlat: "POINT(#{data.fetch(:longitude)} #{data.fetch(:latitude)})")
    # NOTE: alternatively, in high scale I want to assign to async background job rather than blocking sync operation:
    # AddGeolocationWorker.perform_async(identifier)
    #
    # class AddGeolocationWorker
    #   include Sidekiq::Worker
    #
    #   def perform(identifier)
    #     ...
    #   end
    # end
  end
end
