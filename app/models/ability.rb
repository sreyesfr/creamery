class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.employee.role? :admin
      # Administrators
      # (1)
      can :manage, :all
    elsif user.employee.role? :manager
      # Managers
      # (1)
      can :read, Store
      can :read, Job
      can :read, Flavor
      # (2)
      if !user.employee.current_assignment.nil? then
        can :read, Employee do |emp|
          !emp.current_assignment.nil? and emp.current_assignment.store == user.employee.current_assignment.store
        can :read, Assignment, store_id: user.employee.current_assignment.store_id
      # (3,4,5)
        can :manage, Shift.for_store(user.employee.current_assignment.store_id)
      # (6)
        can :create, ShiftJob.for_store(user.employee.current_assignment.store_id)
        can :destroy, ShiftJob.for_store(user.employee.current_assignment.store_id)
      # (7)
        can :create, StoreFlavor, store_id: user.employee.current_assignment.store_id
        can :destroy, StoreFlavor, store_id: user.employee.current_assignment.store_id
      end
      # Managers can also view their own information
        can :read, Assignment, employee_id: user.employee_id
        can :read, User, employee_id: user.employee_id
        can :read, Shift.for_employee(user.employee_id)
        can :read, ShiftJob.for_employee(user.employee_id)
      # Managers can also update their own Employee and User
        can :update, Employee, id: user.employee_id
        can :update, User, employee_id: user.employee_id
    elsif user.employee.role? :employee
      # Employees
      # (1)
      can :read, Store
      can :read, Job
      can :read, Flavor
      # (2)
      can :read, Employee, id: user.employee_id
      can :read, User, employee_id: user.employee_id
      can :read, Assignment, employee_id: user.employee_id
      can :read, Shift.for_employee(user.employee_id)
      can :read, ShiftJob.for_employee(user.employee_id)
      # (3)
      can :update, Employee, id: user.employee_id
      can :update, User, employee_id: user.employee_id
      #can :update, Shift.for_employee(user.employee.id).for_next_days(0)
    else
      can :read, Store, active: true
    end
  end
end
