# NOTE: This class is simple enough for it to not matter, but in theory for more flexible design
# you could seperate the parsing logic here from the networking logic and extract to some kind of adapter.
# That way, the work of adding a new provider is still relatively easy (2, or more, new classes), but the maintanence
# of adapting to a new response structure from the provider is seperated from the other maintanence work
class IpstackClient
  class NetworkError < StandardError; end

  API_KEY = ENV.fetch('IPSTACK_API_KEY')
  BASE_URL = 'http://api.ipstack.com/'.freeze

  def self.search(term:)
    response = HTTP.get("#{BASE_URL}#{term}?access_key=#{API_KEY}")
    json = JSON.parse(response)

    return {} if json['success'] == false

    {
      ip: json['ip'],
      latitude: json.fetch('latitude'),
      longitude: json.fetch('longitude')
    }
  rescue HTTP::Error => e
    Rails.logger.error "Network error: #{e.message}"
    raise e
  end
end
