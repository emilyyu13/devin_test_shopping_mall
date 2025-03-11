class Api::V1::ShipmentsController < ApplicationController
  before_action :set_order
  before_action :set_shipment, only: [:show, :update]

  # POST /api/v1/orders/:order_id/shipments
  def create
    # Check if shipment already exists
    if @order.shipment.present?
      return render json: { error: 'Shipment already exists for this order' }, status: :unprocessable_entity
    end

    # Ensure order is paid before creating shipment
    unless @order.paid?
      return render json: { error: 'Cannot create shipment for unpaid order' }, status: :unprocessable_entity
    end

    @shipment = @order.build_shipment(shipment_params)
    @shipment.status = 'pending'
    
    if @shipment.save
      render json: @shipment, status: :created
    else
      render json: { errors: @shipment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/orders/:order_id/shipments/:id
  def update
    if @shipment.update(shipment_params)
      # If tracking number and carrier are provided, mark as shipped
      if shipment_params[:tracking_number].present? && shipment_params[:carrier].present? && @shipment.status == 'pending'
        @shipment.ship(shipment_params[:tracking_number], shipment_params[:carrier])
      end
      
      # If status is delivered, update shipment and order status
      if shipment_params[:status] == 'delivered'
        @shipment.deliver
      end
      
      render json: @shipment
    else
      render json: { errors: @shipment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/orders/:order_id/shipments/:id
  def show
    render json: @shipment
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Order not found' }, status: :not_found
  end

  def set_shipment
    @shipment = @order.shipment
    render json: { error: 'Shipment not found' }, status: :not_found unless @shipment
  end

  def shipment_params
    params.require(:shipment).permit(:tracking_number, :carrier, :status, :estimated_delivery)
  end
end
