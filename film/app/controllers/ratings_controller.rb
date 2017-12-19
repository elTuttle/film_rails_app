class RatingsController < ApplicationController

  def index
    if Movie.find_by(id: params[:movie_id]).ratings
      @movie = Movie.find(params[:movie_id])
      @ratings = @movie.ratings
    else
      flash[:alert] = "No reviews yet"
      redirect_to movie_path(params[:movie_id])
    end
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @movie}
    end
  end

  def show
    @rating = Rating.find(params[:id])
    @movie = Movie.find(params[:movie_id])
    format.json { render json: @movie}
  end

  def new
    if current_user
      if params[:movie_id]
        @movie = Movie.find(params[:movie_id])
        @movie.ratings.each do |rating|
          if rating.user_id == current_user.id
            flash[:alert] = "User has already reviewed this movie."
          end
        end
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
    respond_to do |format|
      format.html { render :new }
      format.json { render json: @movie}
    end
  end

  def create
    @rating = Rating.create(rating_params)
    @rating.user_id = current_user.id
    @movie = Movie.find(params[:movie_id])
    if @rating.save
      if params[:movie_id]
        @movie.ratings << @rating
        redirect_to movie_ratings_path(params[:movie_id])
      else
        redirect_to rating_path(@rating)
      end
    else
      flash[:error] = @rating.errors.to_a.to_s
      redirect_to new_movie_rating_path(@movie)
    end
  end

  def edit
    if current_user.id == Rating.find(params[:id]).user_id
      @rating = Rating.find(params[:id])
      @location = ""
    else
      flash[:alert] = "Can't edit someone else's film"
      redirect_to movie_ratings_path(@movie)
    end
  end

  def update
    @movie = Movie.find(params[:movie_id])
    @rating = Rating.find(params[:id])
    if @rating.update(rating_params)
      @rating.save
      redirect_to movie_rating_path(@movie, @rating)
    else
      flash[:alert] = "Could not submit Rating"
      redirect_to new_movie_rating_path(@movie)
    end
  end

  def destroy
    @movie = Movie.find(params[:movie_id])
    @rating = Rating.find(params[:id])
    @rating.destroy
    redirect_to movie_ratings_path(@movie)
  end

  private

  def rating_params
    params.require(:rating).permit(:content, :score)
  end

end
