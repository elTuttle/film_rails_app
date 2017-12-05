class MoviesController < ApplicationController

  def index
    @movies = Movie.all
  end

  def new
    if current_user
      @movie = Movie.new
      @movie.actors.build
    else
      flash[:alert] = "Must be logged in to Create Movie"
      redirect_to new_user_session_path
    end
  end

  def create
    if params[:movie][:actor_ids].nil?
      @movie = Movie.new(movie_params_new_actor)
    else
      @movie = Movie.new(movie_params_old_actor)
      @movie.actors << Actor.find(params[:movie][:actor_ids])
    end
    @movie.user_id = current_user.id
    binding.pry
    if @movie.save
      redirect_to movie_path(@movie)
    else
      flash[:alert] = "Could not submit Movie"
      redirect_to new_movie_path
    end
  end

  def show
    @movie = Movie.find(params[:id])
    @actors = @movie.actors
  end

  def edit

  end

  def update

  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_path
  end



  private
  def movie_params_new_actor
    params.require(:movie).permit(:title, :description, actors_attributes: [:name,:age,:bio])
  end

  def movie_params_old_actor
    params.require(:movie).permit(:title, :description)
  end

end
