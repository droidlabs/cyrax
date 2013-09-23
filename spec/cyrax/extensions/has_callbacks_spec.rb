require 'spec_helper'

module Cyrax
  class BaseWithCallbacks < Cyrax::Base
    include Cyrax::Extensions::HasCallbacks
  end

  describe Cyrax::Extensions::HasCallbacks do
    subject { BaseWithCallbacks.new }

    describe '#invoke_callback' do
      context 'when callback handler class is not defined' do
        let(:name) { mock }
        let(:resource) { mock }
        before { subject.class.stub!(:resource_callbacks_handler_class) }
        it { subject.invoke_callback(name, resource).should be_nil }
      end

      context 'when callback handler class is defined' do
        let(:name) { "foo" }
        let(:resource) { mock }
        let(:handle_class) { double.as_null_object }
        before { subject.class.stub!(:resource_callbacks_handler_class).and_return(handle_class) }

        it 'initializes handle class instance' do
          handle_class.should_receive(:new).with(resource)
          subject.invoke_callback(name, resource)
        end

        it 'calls corresponding method on instance' do
          instance = double.as_null_object
          handle_class.stub!(:new).and_return(instance)
          instance.should_receive(:foo)
          subject.invoke_callback(name, resource)
        end
      end
    end

    describe '#callbacks_handler' do
      it 'should define callbacks handler class' do
        subject.class.callbacks_handler('Foo')
        subject.class.resource_callbacks_handler_class.should eq('Foo')
      end
    end
  end
end
