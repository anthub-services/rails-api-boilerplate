class ApplicationController < ActionController::API
  before_action :auth_bearer

  private

    attr_reader :current_user
    attr_reader :token

    def auth_bearer
      @token = Sessions.auth_bearer request.headers

      render status: 401 unless @token

      set_current_user
    end

    def set_current_user
      user = Session.find_by(token: token)

      render status: 401 unless user

      @current_user = user if user
    end
end
