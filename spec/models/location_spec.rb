require 'rails_helper'

RSpec.describe Location, type: :model do
  describe '#add_geolocation!' do
    let(:location) { create(:location_with_url) }

    context 'with valid identifier' do
      let(:client_stub) { double('Client', search: { latitude: 37.419, longitude: 122.075 }) }

      it 'saves the matching geolocation data' do
        expect { location.add_geolocation!(client: client_stub) }.to(change { location.lonlat })
        expect(location.lonlat).to be_a RGeo::Geos::CAPIPointImpl # change if PostGIS adapter implementation changes
      end
    end

    context 'without valid identifier' do
      let(:client_stub) { double('Client', search: {}) }

      it 'raises an error' do
        expect { location.add_geolocation!(client: client_stub) }.to raise_error StandardError
      end
    end
  end
end
