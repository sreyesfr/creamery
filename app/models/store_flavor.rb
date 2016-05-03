class StoreFlavor < ActiveRecord::Base
  include CreameryHelpers::Validations
  # relationships
  belongs_to :store
  belongs_to :flavor
  # validations
  validates_presence_of :store_id, :flavor_id
  validate :store_is_active_in_system, on: :create
  validate :flavor_is_active_in_system, on: :create


  private  
  
  def store_is_active_in_system
    is_active_in_system(:store)
  end

  def flavor_is_active_in_system
    is_active_in_system(:flavor)
  end
end
