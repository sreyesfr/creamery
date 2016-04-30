class FlavorsController < ApplicationController
  before_action :set_flavor, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource
  
  def index
    @active_flavors = Flavor.active.alphabetical.paginate(page: params[:page]).per_page(10)
    @inactive_flavors = Flavor.inactive.alphabetical.paginate(page: params[:page]).per_page(10)  
  end

  def show
  end

  def new
    @flavor = Flavor.new
  end

  def edit
  end

  def create
    @flavor = Flavor.new(flavor_params)
    
    if @flavor.save
      redirect_to flavor_path(@flavor), notice: "Successfully created #{@flavor.name}."
    else
      render action: 'new'
    end
  end

  def update
    if @flavor.update(flavor_params)
      redirect_to flavor_path(@flavor), notice: "Successfully updated #{@flavor.name}."
    else
      render action: 'edit'
    end
  end

  def destroy
    @flavor.destroy
    redirect_to flavors_path, notice: "Successfully removed #{@flavor.name} from the AMC system."
  end

  private
  def set_flavor
    @flavor = Flavor.find(params[:id])
  end

  def flavor_params
    params.require(:flavor).permit(:name, :active)
  end

end