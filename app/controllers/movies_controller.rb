class MoviesController < ApplicationController

@@sort_by = nil
@@checked_ratings_history = ["G", "PG", "PG-13", "R"]


  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    @@sort_by = params[:sort_by] || session[:sort_by]
    @checked_ratings = params[:ratings] || session[:ratings]

    @movies = @movies.order(@@sort_by)
    if @@sort_by == 'title'
      @title_header = 'hilite'
    elsif @@sort_by == 'release_date'
      @release_date_header = 'hilite'
    end

  if @checked_ratings == nil
    @checked_ratings = @all_ratings
    session[:sort_by] = @@sort_by
  else
    session[:ratings] = @checked_ratings
    session[:sort_by] = @@sort_by
    @movies = Movie.where("rating in (?)", @checked_ratings.keys).order(@@sort_by)
  end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
