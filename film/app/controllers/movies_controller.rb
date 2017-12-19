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
    @movie = Movie.new(movie_params)
    if params[:movie][:actor_ids] != nil && params[:movie][:actor_ids] != ""
      @movie.actors << Actor.find(params[:movie][:actor_ids])
    end
    @movie.user_id = current_user.id
    #binding.pry
    if @movie.save
      render json: @movie, status: 201
    else
      flash[:alert] = "Could not submit Movie"
    end
  end

  def show
    @movie = Movie.find(params[:id])
    @actors = @movie.actors
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @movie}
    end
  end

  def edit
    if current_user.id == Movie.find(params[:id]).user_id
      @movie = Movie.find(params[:id])
      @actor = @movie.actors.build
      @actors = @movie.actors
    else
      flash[:alert] = "Can't edit someone else's film"
      redirect_to new_user_session_path
    end
  end

  def remove_actor
    @movie = Movie.find(params[:movie_id])
    @movie.actors.delete(Actor.find(params[:id]))
    if @movie.save
      redirect_to edit_movie_path(@movie)
    else
      flash[:alert] = "Unable to remove actor"
      redirect_to edit_movie_path(@movie)
    end
  end

  def add_actor_page
    @movie = Movie.find(params[:id])
    if current_user.id == @movie.user_id
    else
      redirect_to movie_path(@movie)
    end
  end

  def add_actor
    @movie = Movie.find(params[:id])
    #binding.pry
    if !@movie.actors.find_by(id: params[:movie][:actor_ids])
      if @movie.actors << Actor.find(params[:movie][:actor_ids])
        redirect_to movie_path(@movie)
      else
        flash[:alert] = "Could not add Actor"
        redirect_to movie_path(@movie)
      end
    else
      flash[:alert] = "Actor is already in movie billing"
      redirect_to movie_path(@movie)
    end
  end

  def update
    @movie = Movie.find(params[:id])
    if params[:movie][:actor_ids] != nil && params[:movie][:actor_ids] != ""
      @movie.actors << Actor.find(params[:movie][:actor_ids])
    end
    #binding.pry
    if @movie.update(movie_params)
      @movie.save
      redirect_to movie_path(@movie)
    else
      flash[:alert] = "Could not submit Movie"
      redirect_to new_movie_path
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_path
  end



  private
  def movie_params
    params.require(:movie).permit(:title, :description, actors_attributes: [:name,:age,:bio])
  end
end
