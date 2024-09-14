class MoviesController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies or /movies.json
  def index

    cookies[:sort_column] = { value: sort_column, expires: 1.year.from_now }
    cookies[:sort_direction] = { value: sort_direction, expires: 1.year.from_now }

    @movies = Movie.order(sort_column + " " + sort_direction)

  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to movie_url(@movie), notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to movie_url(@movie), notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy!

    respond_to do |format|
      sort_column = cookies[:sort_column] || 'title'  
      sort_direction = cookies[:sort_direction] || 'asc'
      format.html { redirect_to movies_path(:sort => sort_column, :direction => sort_direction), notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def sort_column
      Movie.column_names.include?(params[:sort]) ? params[:sort] : "title"
    end
  
    def sort_direction
     %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
end
