class EventsController < ApplicationController

  # GET /events
  # GET /events.json
  def index 
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @events = Event.find(:all, order: 'date')
    @events_by_date = @events.group_by{|e| e.date.to_date}
    @event = Event.new       
    respond_to do |format|
      format.js 
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  #def show
  #  @event = Event.find(params[:id])
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.json { render json: @event }
  #  end
  #end

  # GET /events/new
  # GET /events/new.json
  #def new
  #  @event = Event.new
  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.json { render json: @event }
  #  end
  #end

  # GET /events/1/edit
  def edit
    @event_to_update = Event.find(params[:id])
    flash[:alert] = "#{@event_to_update.description[0..25]}... needs some updates!"
    respond_to do |format|
      format.js {}
    end
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        # Re-load updated events
        @date = params[:date] ? Date.parse(params[:date]) : Date.today
        @events = Event.find(:all, order: 'date')
        @events_by_date = @events.group_by{|e| e.date.to_date}
        flash[:notice] = "#{@event.description[0..25]}... has been moved to your coolendar!"
        format.js {}
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.js 
        format.html { render action: "index" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @updated_event = Event.find(params[:id])

    respond_to do |format|
      if @updated_event.update_attributes(params[:event]) 
        flash[:notice] = "#{@updated_event.description[0..25]}... has been updated in your coolendar!"
        # Re-load events + new event instance for next creation
        @date = params[:date] ? Date.parse(params[:date]) : Date.today
        @events = Event.find(:all, order: 'date')
        @events_by_date = @events.group_by{|e| e.date.to_date}
        @event = Event.new
        format.js
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.js
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    flash[:alert] = "#{@event.description[0..25]}... has been removed from your coolendar!"
    @event.destroy

    respond_to do |format|
      # Re-load updated events
      @date = params[:date] ? Date.parse(params[:date]) : Date.today
      @events = Event.find(:all, order: 'date')
      @events_by_date = @events.group_by{|e| e.date.to_date}
      format.js
      format.html { redirect_to events_url}
      format.json { head :no_content }
    end
  end
end
