class Location < ApplicationRecord
  before_create :format_identifier
  validates :identifier, uniqueness: true, presence: true
  validate :valid_url_or_ip

  IP_REGEX = /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
  URL_REGEX = %r{^(?:https?://)?(?:www\.)?[a-zA-Z0-9\-.]+\.[a-zA-Z]{2,}(?:/[^\s]*)?$}

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

  private

  def format_identifier
    self.identifier = identifier.strip
  end

  # NOTE: Another possible approach here is to always resolve the URL to an IP address. but:
  # 1) as my comment in routes.rb illustrates: this isn't necessarily good design (database could accumlate stale records)
  # 2) it increases the latency per API hit
  # Either way, it is worth discussing as this could be downstream a product decision
  def valid_url_or_ip
    return if identifier =~ IP_REGEX || identifier =~ URL_REGEX

    errors.add(:identifier, 'Invalid')
  end
end
