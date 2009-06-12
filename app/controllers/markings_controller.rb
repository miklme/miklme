class MarkingsController < ApplicationController
  # GET /markings
  # GET /markings.xml
  def index
    @markings = Marking.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @markings }
    end
  end

  # GET /markings/1
  # GET /markings/1.xml
  def show
    @marking = Marking.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @marking }
    end
  end

  # GET /markings/new
  # GET /markings/new.xml
  def new
    @marking = Marking.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @marking }
    end
  end

  # GET /markings/1/edit
  def edit
    @marking = Marking.find(params[:id])
  end

  # POST /markings
  # POST /markings.xml
  def create
    @marking = Marking.new(params[:marking])

    respond_to do |format|
      if @marking.save
        flash[:notice] = 'Marking was successfully created.'
        format.html { redirect_to(@marking) }
        format.xml  { render :xml => @marking, :status => :created, :location => @marking }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @marking.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /markings/1
  # PUT /markings/1.xml
  def update
    @marking = Marking.find(params[:id])

    respond_to do |format|
      if @marking.update_attributes(params[:marking])
        flash[:notice] = 'Marking was successfully updated.'
        format.html { redirect_to(@marking) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @marking.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /markings/1
  # DELETE /markings/1.xml
  def destroy
    @marking = Marking.find(params[:id])
    @marking.destroy

    respond_to do |format|
      format.html { redirect_to(markings_url) }
      format.xml  { head :ok }
    end
  end
end
