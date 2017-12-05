class RatingsController < ApplicationController

  def index
    if Movie.find_by(id: params[:movie_id]).ratings
      @ratings = Movie.find(params[:movie_id]).ratings.all
    else
      flash[:alert] = "No reviews yet"
      redirect_to movie_path(params[:movie_id])
    end
  end

  def show
    @rating = Rating.find(params[:id])
  end

  def new
    if current_user
      if params[:movie_id]
        @movie = Movie.find(params[:movie_id])
        @rating = @movie.ratings.build
        @location = movie_ratings_path(@movie,@actor)
      else
        flash[:alert] = "Movie not found"
        redirect_to movie_path(@movie)
      end
    else
      flash[:alert] = "Must be logged in to Write Review"
      redirect_to new_user_session_path
    end
  end

  def create
    @rating = Rating.create(rating_params)
    @rating.user_id = current_user.id
    if @rating.save
      if params[:movie_id]
        @movie = Movie.find(params[:movie_id])
        @movie.ratings << @rating
        redirect_to movie_ratings_path(params[:movie_id])
      else
        redirect_to rating_path(@rating)
      end
    else
      flash[:alert] = "Could not save rating"
      redirect_to new_movie_rating_path(@movie)
    end
  end

  def edit
    if current_user.id == Review.find(params[:id]).user_id
      @rating = Rating.find(params[:id])
    else
      flash[:alert] = "Can't edit someone else's film"
      redirect_to movie_ratings_path
    end
  end

  def update
    @rating = Rating.find(params[:id])
    if @rating.update(rating_params)
      @rating.save
      redirect_to movie_rating_path(@rating)
    else
      flash[:alert] = "Could not submit Rating"
      redirect_to new_movie_rating_path
    end
  end

  def destroy
    @movie = Movie.find(params[:movie_id])
    @rating = Rating.find(params[:id])
    @rating.destroy
    redirect_to movie_ratings_path
  end

  private

  def rating_params
    params.require(:rating).permit(:content, :score)
  end

end
