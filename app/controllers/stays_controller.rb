class StaysController < ApplicationController

  def show

  	#I declare variable that I will use often in the controller and in the view
  	@stay = Stay.find(params[:id])
  	@studio = @stay.studio

  end

  # Even though it wasn't required I added an index to facilitate the navigation
  def index

  	@all_stays = Stay.all

  end

end
