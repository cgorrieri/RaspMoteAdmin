class OutletsController < ApplicationController
  include OutletsHelper

  http_basic_authenticate_with :name => "admin", :password => "admin"

  # GET /outlets
  def index
    #@outlets = Outlet.order("room DESC")

    @outlets = WebService.instance.getlistoutlets
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @outlets }
    end
  end

  # GET /outlets/new
  def new
    @outlet = Outlet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @outlet }
    end
  end

  # GET /outlets/1/edit
  def edit
    @outlet = WebService.instance.getoutlet(params[:id])
  end

  # POST /outlets
  def create
    @outlet = Outlet.new(params[:outlet])

    WebService.instance.addoutlet(@outlet)

    redirect_to outlets_path, notice: 'Outlet was successfully created.'

#    respond_to do |format|
#      if @outlet.save
#        format.html { redirect_to outlets_path, notice: 'Outlet was successfully created.' }
#        format.json { render json: @outlet, status: :created, location: @outlet }
#      else
#        format.html { render action: "new" }
#        format.json { render json: @outlet.errors, status: :unprocessable_entity }
#      end
#    end
  end

  # PUT /outlets/1
  def update
    o = Outlet.new(params[:outlet])
    o.uuid = params[:id]
    WebService.instance.updateoutlet(o)

    redirect_to outlets_path, notice: 'Outlet was successfully updated.'

#    respond_to do |format|
#      if @outlet.update_attributes(params[:outlet])
#        format.html { redirect_to outlets_path, notice: 'Outlet was successfully updated.' }
#        format.json { head :no_content }
#      else
#        format.html { render action: "edit" }
#        format.json { render json: @outlet.errors, status: :unprocessable_entity }
#      end
#    end
  end

  # DELETE /outlets/1
  # DELETE /outlets/1.json
  def destroy
    WebService.instance.removeoutlet(params[:id])
    
    respond_to do |format|
      format.html { redirect_to outlets_url }
      format.json { render :success => true }
    end
  end

  # PUT /outlets/1/true/switchonfoff
  def switchonoff
    WebService.instance.switchonoff(params[:id], params[:state]=="true")
    
    render json: {:success => true}
  end
end
