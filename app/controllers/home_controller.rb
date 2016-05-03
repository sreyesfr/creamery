class HomeController < ApplicationController

  def home
  	if !current_user.nil?
      if current_user.employee.role? :employee then
  	  	@employee = current_user.employee 
  	  	@shifts = @employee.shifts.upcoming.chronological.paginate(page: params[:page]).per_page(5)
        @next_shift = Shift.for_employee(current_user.employee).upcoming.first
      elsif current_user.employee.role? :manager then
        @incomplete_shifts = Shift.incomplete.past.for_store(current_user.employee.current_assignment.store).chronological.paginate(page: params[:incomplete_shifts]).per_page(10)
        @active_flavors = Flavor.active.alphabetical.paginate(page: params[:page]).per_page(10)
      end
  	end 
  end

  def about
  end

  def privacy
  end

  def contact
  end

end