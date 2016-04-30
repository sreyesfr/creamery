class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.employee.role? :admin
      can :manage, :all
    elsif user.employee.role? :manager
      can :read, Store
      can :read, Flavor
      can :read, Job
      can :read, Employee do |employee|
        !employee.current_assignment.nil? and employee.current_assignment.store == user.employee.current_assignment.store
      end
    else
      can :read, :all
    end
  end
end

# elsif user.role? :manager
#     can :update, Band do |band|  
#       band.id == user.band_id
#     end
#     can :destroy, Band do |band|  
#       band.id == user.band_id
#     end
#   elsif user.role? :member
#     can :update, Band do |band|  
#       band.id == user.band_id
#     end
#   end
