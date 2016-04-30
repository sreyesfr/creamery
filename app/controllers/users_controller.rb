class UsersController < ApplicationController
  before_action :check_login, only: [:new, :create]
  before_action :set_user, only: [:edit, :update]
  authorize_resource

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to home_path, :notice => "User account for #{@user.employee.proper_namer} was successfully created."
    else
      flash[:error] = "This user could not be created."
      render :action => "new"
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = "#{@user.employee.proper_name}'s user account was updated."
      redirect_to @user
    else
      render :action => "edit"
    end
  end

  private
  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :employee_id)
  end
end
