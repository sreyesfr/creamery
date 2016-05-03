class StoresController < ApplicationController
  before_action :set_store, only: [:show, :edit, :update, :destroy]
  before_action :check_login, except: [:index, :show]
  authorize_resource
  
  def index
    @active_stores = Store.active.alphabetical.paginate(page: params[:page]).per_page(10)
    @inactive_stores = Store.inactive.alphabetical.paginate(page: params[:page]).per_page(10)  
  end

  def show
    @current_assignments = @store.assignments.current.by_employee.paginate(page: params[:page]).per_page(8)
    @store.get_store_coordinates
  end

  def new
    @store = Store.new
  end

  def edit
  end

  def create
    @store = Store.new(store_params)
    
    if @store.save
      redirect_to store_path(@store), notice: "Successfully created #{@store.name}."
    else
      render action: 'new'
    end
  end

  def update
    if @store.update(store_params)
      redirect_to store_path(@store), notice: "Successfully updated #{@store.name}."
    else
      render action: 'edit'
    end
  end

  def destroy
    @store.destroy
    redirect_to stores_path, notice: "Successfully removed #{@store.name} from the AMC system."
  end

  private
  def set_store
    @store = Store.find(params[:id])
  end

  def store_params
    params.require(:store).permit(:name, :street, :city, :state, :zip, :phone, :active)
  end

end