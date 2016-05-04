class EmployeesController < ApplicationController
  require 'will_paginate/array'
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource

  def index
    @active_employees = Employee.active.alphabetical.paginate(page: params[:employees]).per_page(10)
    @inactive_employees = Employee.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
    @visible_employees = Assignment.current.by_employee.accessible_by(current_ability).map{|a| a.employee}.paginate(page: params[:employees], per_page: 10)
    if current_user.employee.role? :admin then
      @employees = @active_employees
    else
      @employees = @visible_employees
    end
    @completed_shifts = Shift.completed.by_employee.chronological.paginate(page: params[:completed_shifts]).per_page(10)
  end

  def show
    # get the assignment history for this employee
    @assignments = @employee.assignments.chronological.paginate(page: params[:assignment]).per_page(5)
    # get upcoming shifts for this employee (later) 
    @shifts = @employee.shifts.upcoming.chronological.paginate(page: params[:page]).per_page(5)
    @past_shifts = @employee.shifts.past.chronological.reverse_order.paginate(page: params[:past_shifts]).per_page(5)
  end

  def new
    @employee = Employee.new
    @employee.build_user
  end

  def edit
    if @employee.user.nil? then 
      @employee.build_user 
    end
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      redirect_to employee_path(@employee), notice: "Successfully created #{@employee.proper_name}."
    else
      render action: 'new'
    end
  end

  def update
    if @employee.update(employee_params)
      redirect_to employee_path(@employee), notice: "Successfully updated #{@employee.proper_name}."
    else
      render action: 'edit'
    end
  end

  def destroy
    @employee.destroy
    redirect_to employees_path, notice: "Successfully removed #{@employee.proper_name} from the AMC system."
  end

  def search
    search = Employee.search params[:term]
    @employees = search.results
    render 'index' # or your view
  end

  private
  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :ssn, :date_of_birth, :role, :phone, :active, user_attributes: [:id, :email, :password, :password_confirmation, :_destroy])
  end

end