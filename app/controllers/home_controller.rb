class HomeController < ApplicationController

  def home
  	if !current_user.nil?
	  	@employee = current_user.employee 
	  	@shifts = @employee.shifts.upcoming.chronological.paginate(page: params[:page]).per_page(5)
      @next_shift = Shift.for_employee(current_user.employee).upcoming.first
  	end
  end

  def about
  end

  def privacy
  end

  def contact
  end

end