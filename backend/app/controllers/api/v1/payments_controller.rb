class Api::V1::PaymentsController < ApplicationController
  before_action :set_order
  before_action :set_payment, only: [:show]

  # POST /api/v1/orders/:order_id/payments
  def create
    # Check if payment already exists
    if @order.payment.present?
      return render json: { error: 'Payment already exists for this order' }, status: :unprocessable_entity
    end

    @payment = @order.build_payment(payment_params)
    @payment.status = 'pending'
    
    if @payment.save
      # Process the payment (in a real app, this would integrate with a payment gateway)
      @payment.process
      render json: @payment, status: :created
    else
      render json: { errors: @payment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/orders/:order_id/payments/:id
  def show
    render json: @payment
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Order not found' }, status: :not_found
  end

  def set_payment
    @payment = @order.payment
    render json: { error: 'Payment not found' }, status: :not_found unless @payment
  end

  def payment_params
    params.require(:payment).permit(:amount, :payment_method, :transaction_id)
  end
end
