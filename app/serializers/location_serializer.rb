class LocationSerializer
  include JSONAPI::Serializer
  attributes :identifier, :lonlat, :status
end
