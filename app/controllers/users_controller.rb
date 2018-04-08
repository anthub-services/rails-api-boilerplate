class UsersController < ApplicationController
  def index
    render json: Users.list(params), status: 200
  end

  def show
    user = Users.find params[:id]

    render json: user, status: 200 and return if user
    render status: 404
  end

  def create
    user = Users.create params

    render json: { userId: user[:id] }, status: 200 and return if user[:created]
    render json: { message: user[:message] },
           status: 400 and return if user[:email_exists]
    render status: 400
  end

  def update
    user = Users.update params

    render status: 200 and return if user[:updated]
    render json: { message: user[:message] },
           status: 400 and return if user[:email_exists]
  end

  def destroy
    render status: 200 and return if User.destroy params[:id]
    render status: 400
  end
end
