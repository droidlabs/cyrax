require 'spec_helper'

describe Api::ProductsController do
  let(:user) { FactoryGirl.create :user_with_products }
  let(:products) { user.products }
  before { sign_in user }
  subject { JSON.parse(response.body) }

  describe 'GET #index' do
    before { get :index, format: :json }

    it "should return products list" do
      subject.count.should == products.count
    end
  end

  describe 'GET #show' do
    let(:product) { products.first }
    before { get :show, id: product.id, format: :json }

    it "should return serialized product" do
      subject['vendor'].should == product.vendor
    end

    it "should have serialized user" do
      user_attrs = subject['user']
      user_attrs['email'].should == user.email
      user_attrs['name'].should == user.name
      user_attrs.has_key?('created_at').should be true
      user_attrs.has_key?('updated_at').should be false
    end
  end

  describe 'POST #create' do
    let(:attributes) { {vendor: 'some vendor', price_in_cents: 100} }
    before { post :create, product: attributes, format: :json }

    context "on success" do
      it "should return product in json" do
        json = JSON.parse(response.body)
        json['vendor'].should == attributes[:vendor]
        json['vendor'].should_not be_nil
      end
    end

    context "on error" do
      let(:attributes) { {vendor: nil, price_in_cents: 100} }
      it "should return errors in json" do
        json = JSON.parse(response.body)
        json['errors'].should_not be_nil
      end
    end
  end
end
