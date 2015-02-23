class PlacesController < ApplicationController
  def index
  end

  def show
    @place = BeermappingApi.place(params[:id], session[:last_search])
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      session[:last_search] = params[:city]
      render :index
    end
  end
end