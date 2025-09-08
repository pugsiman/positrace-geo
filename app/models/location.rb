class Location < ApplicationRecord
  validates :identifier, uniqueness: true

  def add_geolocation!(client: IpstackClient)
    data = client.search(term: identifier)
    update!(lonlat: "POINT(#{data.fetch(:longitude)} #{data.fetch(:latitude)})", status: :updated)
    # NOTE: alternatively, in high scale I want to assign to async background job rather than a blocking sync operation:
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
  end
end
