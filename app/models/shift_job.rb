class ShiftJob < ActiveRecord::Base
  include CreameryHelpers::Validations
  # relationships
  belongs_to :shift
  belongs_to :job
  has_one :assignment, through: :shift

  # validations
  validates_presence_of :shift_id, :job_id
  validate :shift_is_active_in_system, on: :create
  validate :job_is_active_in_system, on: :create
  # scopes
  scope :for_store, ->(store_id) { joins(:shift).joins(:assignment).where("assignments.store_id = ?", store_id) }
  scope :for_employee, ->(employee_id) { joins(:shift).joins(:assignment).where("assignments.employee_id = ?", employee_id) }

  private  
  
  def shift_is_active_in_system
    is_active_in_system(:shift)
  end

  def job_is_active_in_system
    is_active_in_system(:job)
  end
end
