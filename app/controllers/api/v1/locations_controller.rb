class Api::V1::LocationsController < ApplicationController
  rescue_from Location::GeolocationError, with: :geolocation_error_response

  include BasicAuthentication

  def create
    location = Location.find_or_create_by!(identifier: locations_params.fetch(:identifier))
    location.update_geolocation! # NOTE: We could skip this if location.lonlat already exists, but see comment in model

    render json: LocationSerializer.new(location).serializable_hash, status: 201
  end

  def show
    location = Location.find_by!(identifier: locations_params.fetch(:identifier))
    render json: LocationSerializer.new(location).serializable_hash, status: 200
  end

  def destroy
    location = Location.find_by!(identifier: locations_params.fetch(:identifier))
    location.destroy!
    head :no_content
  end

  private

  def locations_params
    params.permit(:identifier)
  end

  def geolocation_error_response
    render json: { error: 'Geolocation lookup failed' }, status: :unprocessable_entity
  end
end
