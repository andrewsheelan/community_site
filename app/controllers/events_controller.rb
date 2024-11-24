class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :calendar]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @selected_date = params[:date] ? Date.parse(params[:date]) : Date.current
    @month_start = @selected_date.beginning_of_month
    @month_end = @selected_date.end_of_month

    @events = Event.accessible_by(current_ability)
      .includes(:user)
      .where(
        'start_time BETWEEN ? AND ?',
        @month_start.beginning_of_day,
        @month_end.end_of_day
      ).order(start_time: :asc)

    # Get events for selected date if a date is specified
    @date_events = if params[:date]
      @events.where(
        'start_time BETWEEN ? AND ?',
        @selected_date.beginning_of_day,
        @selected_date.end_of_day
      )
    end
  end

  def calendar
    @selected_date = params[:date] ? Date.parse(params[:date]) : Date.current
    @month_start = @selected_date.beginning_of_month
    @month_end = @selected_date.end_of_month

    @events = Event.accessible_by(current_ability)
      .includes(:user)
      .where(
        'start_time BETWEEN ? AND ?',
        @month_start.beginning_of_day,
        @month_end.end_of_day
      ).order(start_time: :asc)

    # Build calendar data
    @calendar_data = (0..5).map do |week|
      (0..6).map do |day|
        date = @month_start + (week * 7 + day).days
        {
          date: date,
          events: @events.select { |e| e.start_time.to_date == date },
          current_month: date.month == @selected_date.month
        }
      end
    end
  end

  def show
    @event_changes = @event.event_changes.includes(:user).order(created_at: :desc)
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.events.build(event_params)

    if @event.save
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_url, notice: 'Event was successfully deleted.'
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :start_time, :end_time, :location)
  end
end
