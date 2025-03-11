class Api::V1::OrderItemsController < ApplicationController
  before_action :set_order
  before_action :set_order_item, only: [:update, :destroy]

  # POST /api/v1/orders/:order_id/order_items
  def create
    @order_item = @order.order_items.new(order_item_params)
    
    if @order_item.save
      @order.calculate_total
      render json: @order_item, status: :created
    else
      render json: { errors: @order_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/orders/:order_id/order_items/:id
  def update
    if @order_item.update(order_item_params)
      @order.calculate_total
      render json: @order_item
    else
      render json: { errors: @order_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/orders/:order_id/order_items/:id
  def destroy
    @order_item.destroy
    @order.calculate_total
    render json: { message: 'Order item successfully deleted' }
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Order not found' }, status: :not_found
  end

  def set_order_item
    @order_item = @order.order_items.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Order item not found' }, status: :not_found
  end

  def order_item_params
    params.require(:order_item).permit(:product_id, :quantity, :price)
  end
end
