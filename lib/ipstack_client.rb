class IpstackClient
  API_KEY = ENV.fetch('IPSTACK_API_KEY')
  BASE_URL = 'http://api.ipstack.com/'.freeze

  def self.search(term:)
    response = HTTP.get("#{BASE_URL}#{term}?access_key=#{API_KEY}")
    json = JSON.parse(response)

    {
      ip: json['ip'],
      latitude: json.fetch('latitude'),
      longitude: json.fetch('longitude')
    }
  end
end
