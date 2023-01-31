class Api::ProductsController < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  def index
    respond_with resource.read_all
  end

  def show
    respond_with resource.read
  end

  def create
    respond_with resource.create, location: false
  end

  def update
    respond_with resource.update, location: false
  end

  def destroy
    respond_with resource.destroy, location: false
  end

  private

  def resource
    @resource ||= Products::UserResource.new(as: current_user, params: params)
  end
end
