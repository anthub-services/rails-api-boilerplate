class IndexController < ApplicationController
  def index
    render json: { message: 'Welcome to Rails API Boilerplate!' }
  end
end
