class ActorsController < ApplicationController

  def index
    @actors = Actor.all
  end

  def show

  end

  def new
    if params[:movie_id]
      @movie = Movie.find(params[:movie_id])
      @actor = @movie.actors.build
      @location = movie_actors_path(@movie,@actor)
    else
      @actor = Actor.new
      @location = actor_path(@actor)
    end
  end

  def create
    if @actor = Actor.create(actor_params)
      #binding.pry
      if params[:movie_id]
        @movie = Movie.find(params[:movie_id])
        @movie.actors << @actor
        if @movie.save
          redirect_to movie_path(params[:movie_id])
        else
          flash[:alert] = "Could not save actor"
          redirect_to new_actor_path
        end
      else
        redirect_to actor_path(@actor)
      end
    else
      flash[:alert] = "Could not save actor"
      redirect_to new_actor_path
    end
  end


  private

  def actor_params
    params.require(:actor).permit(:name, :bio, :age)
  end

end
