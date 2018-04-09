class SessionsController < ApplicationController
  skip_before_action :auth_bearer, only: [:authenticate, :sign_out]

  def index
    render json: Sessions.list(params), status: 200
  end

  def authenticate
    result = Sessions.auth request, params[:token]

    render json: result[:json], status: result[:status]
  end

  def sign_out
    Sessions.sign_out request

    render status: 200
  end

  def verify_token
    render status: 200
  end
end
