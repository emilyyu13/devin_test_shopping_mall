class Api::V1::AuthenticationController < ApplicationController
  # POST /api/v1/login
  def login
    @user = User.find_by(email: params[:email])
    
    if @user&.authenticate(params[:password])
      # In a real app, generate JWT token here
      token = "sample-jwt-token-#{@user.id}"
      render json: { token: token, user_id: @user.id, name: @user.name, role: @user.role }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
end
