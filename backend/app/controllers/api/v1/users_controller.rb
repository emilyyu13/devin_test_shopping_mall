class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update]

  # POST /api/v1/users
  def create
    @user = User.new(user_params)
    @user.role = 'customer' # Default role for new users
    
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/users/:id
  def show
    render json: @user, include: [:shipping_addresses, :orders]
  end

  # PATCH/PUT /api/v1/users/:id
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
