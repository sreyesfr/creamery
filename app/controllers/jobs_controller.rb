class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource
  
  def index
    @active_jobs = Job.active.alphabetical.paginate(page: params[:page]).per_page(10)
    @inactive_jobs = Job.inactive.alphabetical.paginate(page: params[:page]).per_page(10)  
  end

  def show
  end

  def new
    @job = Job.new
  end

  def edit
    unless params[:status].nil?
      if params[:status].match(/make_active/) then
        @job.update_attribute(:active, true)
        @job.save!
        flash[:notice] = "#{@job.name} is now active in the system."
      elsif params[:status].match(/make_inactive/)
        @job.update_attribute(:active, false)
        @job.save!
        flash[:notice] = "#{@job.name} is no longer an active job in the system."
      end
      redirect_to home_path
      return
    end
  end

  def create
    @job = Job.new(job_params)

    respond_to do |format|
      if @job.save
        format.html { redirect_to home_path, notice: 'Job was successfully created.' }
        @jobs = Job.alphabetical #.paginate(page:params[:jobs]).per_page(10)
        format.js
      else
        format.html { render action: 'new' }
        format.js
      end
    end
  end

  def update
    if @job.update(job_params)
      redirect_to home_path, notice: "Successfully updated #{@job.name}."
    else
      render action: 'edit'
    end
  end

  def destroy
    @job.destroy
    redirect_to home_path, notice: "Successfully removed #{@job.name} from the AMC system."
  end

  private
  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:name, :description, :active)
  end

end