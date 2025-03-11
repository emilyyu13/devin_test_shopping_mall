class Api::V1::OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update]

  # GET /api/v1/orders
  def index
    @orders = Order.all
    render json: @orders, include: [:order_items, :payment, :shipment]
  end

  # GET /api/v1/orders/:id
  def show
    render json: @order, include: [:order_items, :payment, :shipment]
  end

  # POST /api/v1/orders
  def create
    @order = Order.new(order_params)
    @order.status = 'pending'
    
    if @order.save
      render json: @order, status: :created
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/orders/:id
  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Order not found' }, status: :not_found
  end

  def order_params
    params.require(:order).permit(:user_id, :status, :total_amount)
  end
end
