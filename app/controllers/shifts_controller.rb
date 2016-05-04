class ShiftsController < ApplicationController
  before_action :set_shift, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource
  
  def index
    @past_shifts = Shift.past.chronological.paginate(page: params[:page]).per_page(10)
    @upcoming_shifts = Shift.upcoming.by_employee.chronological.paginate(page: params[:page]).per_page(10)  
  end

  def show
  end

  def new
    @shift = Shift.new
  end

  def edit     
    @next_shift = Shift.for_employee(current_user.employee).upcoming.first
    # Handle shortcut deactivations
      unless params[:status].nil?
        if params[:status].match(/start/) 
          @next_shift.start_now
          flash[:notice] = "You are now clocked in. Your shift started at #{@next_shift.start_time.strftime("%l:%M %p")}."
        elsif params[:status].match(/end/)
          @next_shift.end_now
          flash[:notice] = "You are now clocked out. Your shift ended at #{@next_shift.end_time.strftime("%l:%M %p")}."
        end
        redirect_to home_path if params[:status].match(/_now/)
      end
  end

  def create
    @shift = Shift.new(shift_params)

    respond_to do |format|
      if @shift.save
        format.html { redirect_to @shift.employee, notice: 'Shift was successfully created.' }
        format.json { render action: 'show', status: :created, location: @shift.employee }
        @employee = @shift.employee
        @shifts = @employee.shifts.to_a
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @shift.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def update
    if @shift.update(shift_params)
      redirect_to home_path, notice: "Successfully updated shift."
    else
      render action: 'edit'
    end
  end

  def destroy
    @shift.destroy
    redirect_to home_path, notice: "Successfully removed shift."
  end

  private
  def set_shift
    @shift = Shift.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:date, :start_time, :end_time, :notes, :assignment_id, shift_jobs_attributes: [:shift_id, :job_id, :_destroy])
  end

end