class Api::V1::ShippingAddressesController < ApplicationController
  before_action :set_user
  before_action :set_shipping_address, only: [:show, :update, :destroy]

  # GET /api/v1/users/:user_id/shipping_addresses
  def index
    @shipping_addresses = @user.shipping_addresses
    render json: @shipping_addresses
  end

  # GET /api/v1/users/:user_id/shipping_addresses/:id
  def show
    render json: @shipping_address
  end

  # POST /api/v1/users/:user_id/shipping_addresses
  def create
    @shipping_address = @user.shipping_addresses.new(shipping_address_params)
    
    if @shipping_address.save
      render json: @shipping_address, status: :created
    else
      render json: { errors: @shipping_address.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/users/:user_id/shipping_addresses/:id
  def update
    if @shipping_address.update(shipping_address_params)
      render json: @shipping_address
    else
      render json: { errors: @shipping_address.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/:user_id/shipping_addresses/:id
  def destroy
    @shipping_address.destroy
    render json: { message: 'Shipping address successfully deleted' }
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  def set_shipping_address
    @shipping_address = @user.shipping_addresses.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Shipping address not found' }, status: :not_found
  end

  def shipping_address_params
    params.require(:shipping_address).permit(:street, :city, :state, :postal_code, :country)
  end
end
