class ProductsController < ApplicationController
  before_action :authenticate_user!
  respond_to :html

  def index
    respond_with resource.read_all
  end

  def show
    respond_with resource.read
  end

  def new
    respond_with resource.build
  end

  def edit
    respond_with resource.edit
  end

  def create
    respond_with resource.create, location: products_path
  end

  def update
    respond_with resource.update, location: products_path
  end

  def destroy
    respond_with resource.destroy, location: products_path
  end

  private

    def resource
      @resource ||= Products::UserResource.new(as: current_user, params: params)
      # you can pass decorator or serializer to override default value
      # @resource ||= Products::UserResource.new(as: current_user, params: params, decorator: CustomDecorator)
    end
end
