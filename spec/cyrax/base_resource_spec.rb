require 'spec_helper'

class Foo; end
module Cyrax
  describe BaseResource do
    describe 'it should behave like resource' do
      context 'class methods' do
        subject { Cyrax::BaseResource }
        it{ should respond_to(:new) }
      end
      context 'instance methods' do
        subject { Cyrax::BaseResource.new }
        it{ should respond_to(:accessor) }
        it{ should respond_to(:params) }
        it{ should respond_to(:resource_name) }
        it{ should respond_to(:resource_class) }
        it{ should respond_to(:resource_scope) }
        it{ should respond_to(:resource_attributes) }
        it{ should respond_to(:build_resource) }
        it{ should respond_to(:build_collection) }
        it{ should respond_to(:find_resource) }
        it{ should respond_to(:assign_resource) }
        it{ should respond_to(:respond_with) }
        it{ should respond_to(:set_message) }
        it{ should respond_to(:add_error) }
        it{ should respond_to(:add_error_unless) }
        it{ should respond_to(:add_errors_from) }
        it{ should respond_to(:invoke_callback) }
      end
    end

    subject { Cyrax::BaseResource.new }
    let(:resource) { mock.as_null_object }
    let(:collection) { [mock] }
    before do
      subject.stub!(:params).and_return({id:123})
      subject.stub!(:find_resource).and_return(resource)
      subject.stub!(:resource_name).and_return('foo')
    end

    describe '#collection' do
      it 'responds with decorated collection' do
        subject.should_receive(:build_collection).and_return(collection)
        subject.should_receive(:respond_with).with(collection, name: 'foos', present: :collection)
        subject.collection
      end
    end

    describe '#build' do
      it 'responds with resource' do
        subject.should_receive(:build_resource).with(nil).and_return(resource)
        subject.should_receive(:respond_with).with(resource)
        subject.build
      end
    end

    describe '#edit' do
      it 'responds with resource' do
        subject.should_receive(:find_resource)
        subject.should_receive(:respond_with).with(resource)
        subject.edit
      end
    end

    describe '#read' do
      it 'responds with resource' do
        subject.should_receive(:find_resource)
        subject.should_receive(:respond_with).with(resource)
        subject.read
      end
    end

    describe '#destroy' do
      it 'responds with resource' do
        subject.should_receive(:find_resource)
        subject.should_receive(:respond_with).with(resource)
        subject.destroy
      end

      it 'destroys resource' do
        resource.should_receive(:destroy)
        subject.destroy
      end

      it 'invokes callbacks' do
        subject.should_receive(:invoke_callback).with(:before_destroy, resource)
        subject.should_receive(:invoke_callback).with(:after_destroy, resource)
        subject.destroy
      end
    end

    describe '#create' do
      let(:params) { {foo: 'bar'} }
      before { subject.stub!(:build_resource).and_return(resource) }
      it 'responds with resource' do
        subject.should_receive(:build_resource).with(nil, params)
        subject.should_receive(:respond_with).with(resource)
        subject.create(params)
      end

      context 'when resource successfully saved' do
        before { resource.stub!(:save).and_return(true) }

        it 'invokes callbacks' do
          subject.should_receive(:invoke_callback).with(:before_save, resource)
          subject.should_receive(:invoke_callback).with(:before_create, resource)
          subject.should_receive(:invoke_callback).with(:after_save, resource)
          subject.should_receive(:invoke_callback).with(:after_create, resource)
          subject.create(params)
        end

        it 'sets message' do
          subject.should_receive(:set_message).with('Foo successfully created')
          subject.create(params)
        end
      end

      context 'when resource could not be saved' do
        before { resource.stub!(:save).and_return(false) }

        it 'invokes callbacks' do
          subject.should_receive(:invoke_callback).with(:before_save, resource)
          subject.should_receive(:invoke_callback).with(:before_create, resource)
          subject.should_not_receive(:invoke_callback).with(:after_save, resource)
          subject.should_not_receive(:invoke_callback).with(:after_create, resource)
          subject.create(params)
        end

        it 'sets error messages' do
          subject.should_receive(:add_errors_from).with(resource)
          subject.create(params)
        end
      end
    end

    describe '#update' do
      let(:params) { {foo: 'bar'} }
      before { subject.stub!(:build_resource).and_return(resource) }
      it 'responds with resource' do
        subject.should_receive(:build_resource).with(123, params)
        subject.should_receive(:respond_with).with(resource)
        subject.update(params)
      end

      context 'when resource successfully saved' do
        before { resource.stub!(:save).and_return(true) }

        it 'invokes callbacks' do
          subject.should_receive(:invoke_callback).with(:before_save, resource)
          subject.should_receive(:invoke_callback).with(:before_update, resource)
          subject.should_receive(:invoke_callback).with(:after_save, resource)
          subject.should_receive(:invoke_callback).with(:after_update, resource)
          subject.update(params)
        end

        it 'sets message' do
          subject.should_receive(:set_message).with('Foo successfully updated')
          subject.update(params)
        end
      end

      context 'when resource could not be saved' do
        before { resource.stub!(:save).and_return(false) }

        it 'invokes callbacks' do
          subject.should_receive(:invoke_callback).with(:before_save, resource)
          subject.should_receive(:invoke_callback).with(:before_update, resource)
          subject.should_not_receive(:invoke_callback).with(:after_save, resource)
          subject.should_not_receive(:invoke_callback).with(:after_update, resource)
          subject.update(params)
        end

        it 'sets error messages' do
          subject.should_receive(:add_errors_from).with(resource)
          subject.update(params)
        end
      end
    end
  end
end
