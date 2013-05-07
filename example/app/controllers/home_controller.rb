class HomeController < ApplicationController
  respond_to :html

  def index
    respond_with Products::BaseResource.new.collection
  end
end
