class LocationsController < ApplicationController
  before_action :redirect_unless_admin
  before_action :set_location, only: [:show]

  def index
    @locations = Location.all
  end

  def show
  end

  private

  def redirect_unless_admin
    redirect_to(root_path) unless current_admin_user
  end

  def set_location
    @location = Location.find(params[:id])
  end
end
