require 'spec_helper'

describe ProductsController do
  let(:user) { FactoryGirl.create(:user) }
  before(:each) do
    # @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    subject.current_user
  end

  # This should return the minimal set of attributes required to create a valid
  # Product. As you add validations to Product, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "vendor" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ProductsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns and decorate all products as @products" do
      product = user.products.create! valid_attributes
      get :index, {}, valid_session
      # response.should be_success
      assigns(:products).should be_kind_of(Cyrax::Presenters::BaseCollection)
      assigns(:products).first.should be_kind_of(Products::Decorator) #.new(product)])
    end
  end

  describe "GET show" do
    it "assigns the requested product as @product" do
      product = user.products.create! valid_attributes
      get :show, {:id => product.to_param}, valid_session
      assigns(:product).to_model.should eq(product)
    end
  end

  describe "GET new" do
    it "assigns a new product as @product" do
      get :new, {}, valid_session
      assigns(:product).to_model.should be_a_new(Product)
    end
  end

  describe "GET edit" do
    it "assigns the requested product as @product" do
      product = user.products.create! valid_attributes
      get :edit, {:id => product.to_param}, valid_session
      assigns(:product).to_model.should eq(product)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Product" do
        expect {
          post :create, {:product => valid_attributes}, valid_session
        }.to change(Product, :count).by(1)
      end

      it "assigns a newly created product as @product" do
        post :create, {:product => valid_attributes}, valid_session
        assigns(:product).to_model.should be_a(Product)
        assigns(:product).to_model.should be_persisted
      end

      it "redirects to the created product" do
        post :create, {:product => valid_attributes}, valid_session
        response.should redirect_to(products_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved product as @product" do
        # Trigger the behavior that occurs when invalid params are submitted
        Product.any_instance.stub(:save).and_return(false)
        post :create, {:product => { "vendor" => "invalid value" }}, valid_session
        assigns(:product).to_model.should be_a_new(Product)
      end

      it "sets 302 response status" do
        # Trigger the behavior that occurs when invalid params are submitted
        Product.any_instance.stub(:save).and_return(false)
        post :create, {:product => { "vendor" => "invalid value" }}, valid_session
        response.status.should eq(302)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do

      it "assigns the requested product as @product" do
        product = user.products.create! valid_attributes
        put :update, {:id => product.to_param, :product => valid_attributes}, valid_session
        assigns(:product).to_model.should eq(product)
      end

      it "redirects to the product" do
        product = user.products.create! valid_attributes
        put :update, {:id => product.to_param, :product => valid_attributes}, valid_session
        response.should redirect_to(products_url)
      end
    end

    describe "with invalid params" do
      it "assigns the product as @product" do
        product = user.products.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Product.any_instance.stub(:save).and_return(false)
        put :update, {:id => product.to_param, :product => { "vendor" => "invalid value" }}, valid_session
        assigns(:product).to_model.should eq(product)
      end

      it "sets 302 response status" do
        product = user.products.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Product.any_instance.stub(:save).and_return(false)
        put :update, {:id => product.to_param, :product => { "vendor" => "invalid value" }}, valid_session
        response.status.should eq(302)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested product" do
      product = user.products.create! valid_attributes
      expect {
        delete :destroy, {:id => product.to_param}, valid_session
      }.to change(Product, :count).by(-1)
    end

    it "redirects to the products list" do
      product = user.products.create! valid_attributes
      delete :destroy, {:id => product.to_param}, valid_session
      response.should redirect_to(products_url)
    end
  end

end
