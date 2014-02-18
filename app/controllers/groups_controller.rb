class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    order = get_order_string
    result = ActiveRecord::Base.connection.execute(
      "SELECT * FROM groups ORDER BY #{order}")
    @groups = []
    result.each() {|item| @groups << item}
    @group = Group.new
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    result = ActiveRecord::Base.connection.execute(
      "SELECT * FROM members WHERE group_id = #{@group['id']}")
    @members = []
    result.each() {|item| @members << item}
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    title = group_params['title'].trim
    formation_year = group_params['formation_year']=='' ? 'NULL' : group_params['formation_year'].to_i
    country = group_params['country'].trim
    top_position = group_params['top_position']=='' ? 'NULL' : group_params['top_position'].to_i

    saved = transact("INSERT INTO groups (title,
                                          formation_year,
                                          country, 
                                          top_position, 
                                          created_at, 
                                          updated_at)
                      VALUES (#{title == ''? 'NULL' : '\''+title+'\''},
                              #{formation_year},
                              '#{country}',
                              #{top_position},
                              '#{Time.now.to_s(:db)}',
                              '#{Time.now.to_s(:db)}')")
    @group = Group.new(group_params)

    respond_to do |format|
      if saved
        format.html { redirect_to groups_url }
      else
        format.html { redirect_to groups_url, flash: { error: "ACHTUNGEN!!!" } }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:title, :formation_year, :country, :top_position)
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
