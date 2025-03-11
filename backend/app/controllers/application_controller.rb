class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  # Skip authentication for now to simplify development
  # Uncomment to enable authentication
  # before_action :authenticate

  protected

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token, options|
      # In a real app, verify JWT token here
      # For now, just check if token exists
      token.present?
    end
  end

  def render_unauthorized
    render json: { error: 'Access denied' }, status: :unauthorized
  end
end
