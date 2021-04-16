class UrlsController < ApplicationController
  before_action :set_url, only: %i[ show edit update destroy ]

  # GET /urls or /urls.json
  def index
    @urls = Url.where(user_id: current_user)
  end

  # GET /urls/1 or /urls/1.json
  def show
    @url.update(num_clicks: (@url.num_clicks + 1))
    redirect_to @url.long_url
  end

  def download
    @urls = Url.where(user_id: current_user)
    send_data @urls.to_csv, filename: "shrtn-url-#{Date.today}.csv"
  end

  # GET /urls/new
  def new
    @url = Url.new
  end

  # GET /search
  def search
    @url_table = Url.search(params[:inquiry], current_user.id)
  end

  # POST /urls or /urls.json
  def create
    @url = Url.new(url_params)
    @url.num_clicks = 0
    @url.short_url = helpers.generate_short_url
    @url.long_url = helpers.clean_up(@url.long_url)

    respond_to do |format|
      if @url.save
        format.html { redirect_to user_path(current_user), notice: "Url was successfully created, short link: #{@url.short_url}" }
        format.json { render :index, status: :created, location: @url }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /urls/1 or /urls/1.json
  def update
    respond_to do |format|
      if @url.update(url_params)
        format.html { redirect_to @url, notice: "Url was successfully updated." }
        format.json { render :show, status: :ok, location: @url }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /urls/1 or /urls/1.json
  def destroy
    @url.destroy
    respond_to do |format|
      format.html { redirect_to urls_url, notice: "Url was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url
      @url = Url.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def url_params
      params.require(:url).permit(:long_url, :short_url, :num_clicks, :user_id, :search)
    end
end
