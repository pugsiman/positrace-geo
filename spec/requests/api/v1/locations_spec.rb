require 'rails_helper'

RSpec.describe 'Api::V1::Locations', type: :request do
  describe 'POST /locations', :vcr do
    context 'with url identifier' do
      it 'creates a location record with geolocation data' do
        post '/api/v1/locations', params: { identifier: build(:location_with_url).identifier }, as: :json
        expect(response).to have_http_status(:created)
      end
    end

    context 'with IP identifier' do
      it 'creates a location record with geolocation data' do
        post '/api/v1/locations', params: { identifier: build(:location_with_ip).identifier }, as: :json
        expect(response).to have_http_status(:created)
      end
    end

    context 'with nonsense identifier' do
      it 'returns an error' do
        post '/api/1/locations', params: { identifier: '000000000' }, as: :json
        expect(response).to have_http_status(404)
      end
    end

    context 'when record with the same identifier already exists' do
      let!(:location) { create(:location_with_url) }

      it 'updates the existing record' do
        post '/api/v1/locations', params: { identifier: location.identifier }, as: :json
        expect(response).to have_http_status(201)
      end
    end
  end

  describe 'GET /locations/' do
    context 'with existing record' do
      let!(:location) { create(:location_with_url) }

      it 'returns data about queried record' do
        get "/api/v1/locations/#{location.identifier}", as: :json
        expect(response).to have_http_status(:success)
      end
    end
    context 'with unknown record' do
      it 'returns an error' do
        get '/api/v1/locations/non-existing-identifier'
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'DELETE /locations/' do
    let!(:location) { create(:location_with_url) }

    it 'deletes the record by identifier' do
      delete "/api/v1/locations/#{location.identifier}"
      expect(response).to have_http_status(:success)
      expect { location.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    context 'when record does not exist with identifier' do
      it 'returns an error' do
        delete '/api/v1/locations/999.999.999.999'
        expect(response).to have_http_status(404)
      end
    end
  end
end
