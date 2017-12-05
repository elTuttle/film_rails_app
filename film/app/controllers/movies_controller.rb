class MoviesController < ApplicationController

  def index
    @movies = Movie.all
  end

  def new
    @movie = Movie.new
    @movie.actors.build
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to movie_path(@movie)
    else
      flash[:alert] = "Could not submit Movie"
      redirect_to new_movie_path
    end
  end

  def show
    @movie = Movie.find(params[:id])
  end



  private
  def movie_params
    params.require(:movie).permit(:title, :description, :actor_ids => [], actor_attributes: [:name,:age,:bio])
  end

end
