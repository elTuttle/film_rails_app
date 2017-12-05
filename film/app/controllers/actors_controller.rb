class ActorsController < ApplicationController

  def index
    @actors = Actor.all
  end

  def show
    @actor = Actor.find(params[:id])
  end

  def new
    if current_user
      if params[:movie_id]
        @movie = Movie.find(params[:movie_id])
        @actor = @movie.actors.build
        @location = movie_actors_path(@movie,@actor)
      else
        @actor = Actor.new
        @location = ""
      end
    else
      flash[:alert] = "Must be logged in to Create Movie"
      redirect_to new_user_session_path
    end
  end

  def create
    @actor = Actor.create(actor_params)
    if @actor.save
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
      flash[:alert] = "Could not save actor, might already exist or name field was empty"
      redirect_to new_actor_path
    end
  end

  def destroy
    @actor = Actor.find(params[:id])
    @actor.destroy
    redirect_to actors_path
  end


  private

  def actor_params
    params.require(:actor).permit(:name, :bio, :age)
  end

end
