class HomeController < ApplicationController
  respond_to :html

  def index
    respond_with Products::BaseResource.new(params: params).read_all
  end
end
