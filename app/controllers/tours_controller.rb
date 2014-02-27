class ToursController < ApplicationController
  before_action :set_tour, only: [:show, :edit, :update, :destroy]

  # GET /tours
  # GET /tours.json
  def index
    @tours = Tour.get_by_group_id(params['group_id'].to_i)
    @group = Group.get_one(params['group_id'].to_i)
  end

  # GET /tours/1
  # GET /tours/1.json
  def show
    @group = Group.get_one(params['group_id'].to_i)
    @concerts = @tour.get_concerts()
    @concerts.each() do |concert| 
      concert['ticket_price'] = ((0.5+1.0/@group['top_position'])*(15000.0/concert['country'].length)).to_i
    end
  end

  # GET /tours/new
  def new
    @group = Group.get_one(params['group_id'].to_i)
    @tour = Tour.new
    @tour.group_id = @group.id
    @concert = Concert.new
  end

  # GET /tours/1/edit
  def edit
  end

  # POST /tours
  # POST /tours.json
  def create
    @tour = Tour.new(tour_params)
    @concert = Concert.new(concert_params)

    if id = @tour.save
      @concert.tour_id = id
      done = @concert.save
    end

    respond_to do |format|
      if done
        format.html { redirect_to group_tour_path(@tour.group_id, @tour.id), notice: 'Концертный тур успешно добавлен.' }
      else
        @tour.delete
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /tours/1
  # PATCH/PUT /tours/1.json
  def update
    respond_to do |format|
      if @tour.update(tour_params)
        format.html { redirect_to group_tours_path(@tour.group_id), notice: 'Данные концертного тура успешно обновлены.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /tours/1
  # DELETE /tours/1.json
  def destroy
    @tour.delete
    respond_to do |format|
      format.html { redirect_to group_tours_path(@tour.group_id) }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tour
      @tour = Tour.get_one(params[:id].to_i)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tour_params
      params.require(:tour).permit(:title, :group_id)
    end

    def concert_params
      pars = params.require(:concert).permit! do |whitelist|
        whitelist['city'] = params['concert']['city'].trim.downcase
        whitelist['country'] = params['concert']['country'].trim.downcase
        whitelist['date(1i)'] = params['concert']['date(1i)'].to_i
        whitelist['date(2i)'] = params['concert']['date(2i)'].to_i
        whitelist['date(3i)'] = params['concert']['date(3i)'].to_i
      end
      pars['date'] = 
          pars.delete('date(1i)') + '-' +
          pars.delete('date(2i)') + '-' +
          pars.delete('date(3i)')
      pars
    end
end
