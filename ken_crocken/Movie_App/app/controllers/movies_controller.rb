class MoviesController < ApplicationController

  def index
    @my_movies = Movie.all
  end

  def search
    @my_movies = Movie.search_movie(params[:q])
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      flash[:success] = "Movie saved."
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def update
    @movie = Movie.find(params[:id])
    if @movie.update(movie_params)
      flash[:success] = "Movie updated."
      redirect_to movies_path
    else
      render 'edit'
    end   
  end

  def destroy
    Movie.find(params[:id]).destroy
    flash[:success] = "Movie deleted."
    redirect_to root_path
  end

  private

    def movie_params
      params.require(:movie).permit(:title, :description, :year_released, :rating)
    end

end
