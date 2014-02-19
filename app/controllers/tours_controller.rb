class ToursController < ApplicationController
  before_action :set_tour, only: [:show, :edit, :update, :destroy]

  # GET /tours
  # GET /tours.json
  def index
    query =  "SELECT
                t.id, t.title, t.group_id, d.begin_date, d.end_date
              FROM
                tours t
              INNER JOIN
                ( SELECT MIN(date) AS begin_date,
                       MAX(date) AS end_date,
                       tour_id
                 FROM concerts
                ) d ON t.id = d.tour_id
              WHERE t.group_id=#{params['group_id']}"
              
    result = ActiveRecord::Base.connection.execute(query)
    @tours = []
    result.each(){|tour| @tours << tour}

    query = "SELECT id, title FROM groups
              WHERE id=#{params['group_id']}"
    result = ActiveRecord::Base.connection.execute(query)
    @group = result[0]
  end

  # GET /tours/1
  # GET /tours/1.json
  def show
    query = "SELECT title, top_position FROM groups
              WHERE id=#{params['group_id']}"
    result = ActiveRecord::Base.connection.execute(query)
    @group = result[0]

    query = "SELECT * FROM concerts
             WHERE tour_id = #{params['id']}
             ORDER BY date ASC"
    result = ActiveRecord::Base.connection.execute(query)
    @concerts = []
    result.each() do |concert| 
      concert['ticket_price'] = ((0.5+1.0/@group['top_position'])*(15000.0/concert['country'].length)).to_i
      @concerts << concert
    end
  end

  # GET /tours/new
  def new
    @tour = Tour.new
  end

  # GET /tours/1/edit
  def edit
  end

  # POST /tours
  # POST /tours.json
  def create
    @tour = Tour.new(tour_params)

    respond_to do |format|
      if @tour.save
        format.html { redirect_to @tour, notice: 'Tour was successfully created.' }
        format.json { render action: 'show', status: :created, location: @tour }
      else
        format.html { render action: 'new' }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tours/1
  # PATCH/PUT /tours/1.json
  def update
    respond_to do |format|
      if @tour.update(tour_params)
        format.html { redirect_to @tour, notice: 'Tour was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tours/1
  # DELETE /tours/1.json
  def destroy
    @tour.destroy
    respond_to do |format|
      format.html { redirect_to tours_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tour
      @tour = Tour.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tour_params
      params.require(:tour).permit(:title, :group_id)
    end
end
