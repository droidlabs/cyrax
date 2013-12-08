require 'spec_helper'

class Foo; end
module Cyrax
  describe Resource do
    describe 'it should behave like resource' do
      context 'instance methods' do
        subject { Cyrax::Resource.new }
        it{ should respond_to(:accessor) }
        it{ should respond_to(:params) }
        it{ should respond_to(:resource_name) }
        it{ should respond_to(:resource_class) }
        it{ should respond_to(:resource_attributes) }
        it{ should respond_to(:assign_resource) }
        it{ should respond_to(:respond_with) }
        it{ should respond_to(:set_message) }
        it{ should respond_to(:add_error) }
        it{ should respond_to(:add_error_unless) }
        it{ should respond_to(:sync_errors_with) }
      end
    end

    subject { Cyrax::Resource.new }
    let(:repository) { double }
    let(:resource) { double.as_null_object }
    let(:collection) { [double] }
    before do
      subject.stub(:params).and_return({id:123})
      subject.stub(:repository).and_return(repository)
      repository.stub(:find).and_return(resource)
      subject.class.send :resource, :foo
    end

    describe '#read_all' do
      it 'responds with decorated collection' do
        repository.should_receive(:find_all).and_return(collection)
        subject.should_receive(:respond_with).with(collection, name: 'foos', present: :collection)
        subject.read_all
      end
    end

    describe '#build' do
      it 'responds with resource' do
        repository.should_receive(:build).with(nil).and_return(resource)
        subject.should_receive(:respond_with).with(resource)
        subject.build
      end
    end

    describe '#edit' do
      it 'responds with resource' do
        repository.should_receive(:find)
        subject.should_receive(:respond_with).with(resource)
        subject.edit
      end
    end

    describe '#read' do
      it 'responds with resource' do
        repository.should_receive(:find)
        subject.should_receive(:respond_with).with(resource)
        subject.read
      end
    end

    describe '#destroy' do
      it 'destroys resource and responds with resource' do
        repository.should_receive(:find)
        repository.should_receive(:delete)
        subject.should_receive(:respond_with).with(resource)
        subject.destroy
      end
    end

    describe '#create' do
      let(:params) { {foo: 'bar'} }
      before { repository.stub(:build).and_return(resource) }
      it 'responds with resource' do
        repository.should_receive(:save).with(resource)
        repository.should_receive(:build).with(nil, params)
        subject.should_receive(:respond_with).with(resource)
        subject.create(params)
      end

      context 'when resource successfully saved' do
        before { repository.stub(:save).and_return(true) }

        it 'sets message' do
          subject.should_receive(:set_message).with(:created)
          subject.create(params)
        end
      end

      context 'when resource could not be saved' do
        before { repository.stub(:save).and_return(false) }

        it 'does not set message' do
          subject.should_not_receive(:set_message).with(:created)
          subject.create(params)
        end
      end
    end

    describe '#update' do
      let(:params) { {foo: 'bar'} }
      before { repository.stub(:build).and_return(resource) }
      it 'responds with resource' do
        repository.should_receive(:build).with(123, params)
        repository.should_receive(:save).with(resource)
        subject.should_receive(:respond_with).with(resource)
        subject.update(params)
      end

      context 'when resource successfully saved' do
        before { repository.stub(:save).and_return(true) }

        it 'sets message' do
          subject.should_receive(:set_message).with(:updated)
          subject.update(params)
        end
      end

      context 'when resource could not be saved' do
        before { repository.stub(:save).and_return(false) }

        it 'does not set message' do
          subject.should_not_receive(:set_message).with(:created)
          subject.create(params)
        end
      end
    end
  end
end
