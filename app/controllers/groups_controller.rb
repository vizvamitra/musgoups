class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    order_by = params['order_by']
    order = params['order']
    order_by = 'title' unless ['formation_year', 'country',
                               'top_position'].include?(order_by)
    order = 'asc' unless order == 'desc'

    @groups = Group.get_all(order_by, order)
    @groups.each() do |item|
      item['title'][0] = item['title'][0].upcase
      item['country'][0] = item['country'][0].upcase unless item['country'] == ''
    end
    @group = Group.new
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /songs/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Группа успешно создана.' }
      else
        format.html { redirect_to groups_url, flash: { error: error } }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Данные группы успешно обновлены.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.delete
    respond_to do |format|
      format.html { redirect_to groups_url }
    end
  end

  def task
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.get_one(params[:id].to_i)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit! do |whitelist|
        whtelist['title'] = params['group']['title'].trim.downcase
        whtelist['formation_year'] = params['group']['formation_year'].to_i
        whtelist['country'] = params['group']['country'].trim.downcase
        whtelist['top_position'] = params['group']['top_position'].to_i
      end
    end

    def get_order_string
      case params['order_by']
        when 'formation_year' then 'formation_year' 
        when 'country' then 'country'
        when 'top_position' then 'top_position'
        else 'title'
      end +
      case params['order']
        when 'asc' then ' ASC'
        when 'desc' then ' DESC'
        else ''
      end
    end
end
