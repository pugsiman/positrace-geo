# NOTE: This class is simple enough for it to not matter, but in theory for more flexible design
# you could seperate the parsing logic here from the networking logic and extract to some kind of adapter.
# That way, the work of adding a new provider is still relatively easy (2, or more, new classes), but the maintanence
# of adapting to a new response structure from the provider is seperated from the other maintanence work
class IpstackClient < GeolocationClient
  API_KEY = ENV.fetch('IPSTACK_API_KEY') # could be extracted to confugration
  BASE_URL = 'http://api.ipstack.com/'.freeze

  attr_accessor :adapter

  def search(term:)
    response = HTTP.get("#{BASE_URL}#{term}?access_key=#{API_KEY}")
    json = JSON.parse(response)
    # Or: adapter.parse(response)

    # the client only treats network specific errors as relevant and lets the caller handle its domain specific ones
    return {} if json['success'] == false

    {
      ip: json['ip'],
      latitude: json.fetch('latitude'),
      longitude: json.fetch('longitude')
    }
  rescue HTTP::Error => e
    # NOTE: In theory, we would propagate this throgh something like GeolocationClient::ERRORS,
    # then have appropriate error handling for network errors specifically
    Rails.logger.error "Network error: #{e.message}"
    raise NetworkError, e.message
  end
end
