class Api::V1::LocationsController < ApplicationController
  def create
    location = Location.find_or_create_by(identifier: locations_params.fetch(:identifier))
    location.update_geolocation!

    render json: location, status: 201
  end

  def show
    location = Location.find_by!(identifier: locations_params.fetch(:identifier))
    render json: location, status: 200
  end

  def destroy
    location = Location.find_by!(identifier: locations_params.fetch(:identifier))
    location.destroy!
    render json: location, status: 200
  end

  private

  def locations_params
    params.permit(:identifier)
  end
end
