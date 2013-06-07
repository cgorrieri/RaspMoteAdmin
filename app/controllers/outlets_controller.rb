class OutletsController < ApplicationController
  include OutletsHelper

  http_basic_authenticate_with :name => "admin", :password => "admin"

  # GET /outlets
  # GET /outlets.json
  def index
    #@outlets = Outlet.order("room DESC")

    @outlets = WebService.instance.getlistoutlets
    logger.debug @outlets
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @outlets }
    end
  end

  # GET /outlets/new
  # GET /outlets/new.json
  def new
    @outlet = Outlet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @outlet }
    end
  end

  # GET /outlets/1/edit
  def edit
    @outlet = Outlet.find(params[:id])
  end

  # POST /outlets
  # POST /outlets.json
  def create
    @outlet = Outlet.new(params[:outlet])

    WebService.instance.addoutlet(@outlet)
    logger.debug @outlet

    respond_to do |format|
      if @outlet.save
        format.html { redirect_to outlets_path, notice: 'Outlet was successfully created.' }
        format.json { render json: @outlet, status: :created, location: @outlet }
      else
        format.html { render action: "new" }
        format.json { render json: @outlet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /outlets/1
  # PUT /outlets/1.json
  def update
    @outlet = Outlet.find(params[:id])

    respond_to do |format|
      if @outlet.update_attributes(params[:outlet])
        format.html { redirect_to outlets_path, notice: 'Outlet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @outlet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /outlets/1
  # DELETE /outlets/1.json
  def destroy
    @outlet = Outlet.find(params[:id])
    WebService.instance.removeoutlet(@outlet)
    @outlet.destroy

    respond_to do |format|
      format.html { redirect_to outlets_url }
      format.json { render :success => true }
    end
  end

  # PUT /outlets/1/switchonfoff
  # PUT /outlets/1.json
  def switchonoff
    outlet = Outlet.find(params[:id])
    WebService.instance.switchonoff(outlet.uuid, !outlet.state)
    outlet.update_attributes({state: !outlet.state})
    
    render json: {:success => true}
  end
end
