class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]
  load_and_authorize_resource

  def index
    @users = User.accessible_by(current_ability)
      .includes(:roles)
      .order(created_at: :desc)
  end

  def show
  end

  def edit
  end

  def update
    if user_params[:role_ids].present? && can?(:manage, User)
      update_roles
    end

    if @user.update(user_params.except(:role_ids))
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, role_ids: [])
  end

  def update_roles
    # Remove all existing roles
    @user.roles.clear
    
    # Add selected roles
    role_ids = user_params[:role_ids].reject(&:blank?).map(&:to_i)
    role_ids.each do |role_id|
      role = Role.find(role_id)
      @user.add_role(role.name)
    end
  end
end
