class MoviesController < ApplicationController

  def index
    @movies = Movie.all
  end

  def new
    @movie = Movie.new
  end

  def create

  end

  def show
    @movie = Movie.find(params[:id])
  end



  private
  def movie_params
    params.require(:movie).permit(:title, :description, :actor_ids => [], actor_attributes: [:name,:age,:bio])
  end

end
