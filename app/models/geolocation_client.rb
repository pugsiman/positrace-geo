class GeolocationClient
  class NetworkError < StandardError; end
  class MissingProviderError < StandardError; end

  def self.create(provider: Rails.configuration.x.geolocation.api_provider) # or whatever
    case provider.to_sym
    when :ipstack
      # NOTE: for more extendibility, we could extract the parsing/adapting logic into its own class, and plug them during this construction
      IpstackClient.new.tap do |client|
        # client.adapter = IpstackAdapter etc.
      end
    when :some_other_service
      # SomeOtherClient.new
    else
      raise MissingProviderError, "Unknown geolocation provider: #{provider}"
    end
  end

  def search(term:)
    raise NotImplementedError, "#{self.class} must implement #search"
  end
end
