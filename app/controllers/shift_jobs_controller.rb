class ShiftJobsController < ApplicationController
  before_action :set_shift_job, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource
  
  def index
    
  end

  def show
  end

  def new
    @shift_job = ShiftJob.new
  end

  def edit
  end

  def create
    @shift_job = ShiftJob.new(shift_job_params)
    if @shift_job.save
      redirect_to home_path, notice: "Successfully added a job to the shift."
    else
      render action: 'new'
    end
  end

  def update
    if @shift_job.update(shift_job_params)
      redirect_to home_path, notice: "Successfully updated the job for this shift."
    else
      render action: 'edit'
    end
  end

  def destroy
    @shift_job.destroy
    redirect_to home_path, notice: "Successfully removed the job from this shift."
  end

  private
  def set_shift_job
    @shift_job = ShiftJob.find(params[:id])
  end

  def shift_job_params
    params.require(:shift_job).permit(:shift_id, :job_id)
  end
end