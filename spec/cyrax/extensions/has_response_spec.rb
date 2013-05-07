require 'spec_helper'

module Cyrax
  describe Cyrax::Extensions::HasResponse do
    include Cyrax::Extensions::HasResponse

    subject { self }

    describe '#set_message' do
      it 'should set message' do
        subject.set_message('foo')
        subject.instance_variable_get(:@_message).should eq('foo')
      end
    end

    describe '#add_error' do
      it 'should add error' do
        subject.add_error('foo')
        subject.instance_variable_get(:@_errors).should include('foo')
      end
    end

    describe '#add_error_unless' do
      it 'should add error when condition false' do
        subject.add_error_unless('foo', 1==0)
        subject.instance_variable_get(:@_errors).should include('foo')
      end

      it 'should not add error when condition true' do
        subject.add_error_unless('foo', 1==1)
        subject.instance_variable_get(:@_errors).should be_nil
      end
    end

    describe '#add_errors_from' do
      let(:messages) { [[:foo, 'bar'], [:bar, 'bazz']]}
      let(:errors) { mock(messages: messages)}
      let(:model) { mock(errors: errors) }

      it 'should add errors from model error messages' do
        subject.add_errors_from(model)
        subject.instance_variable_get(:@_errors).should eq(['foo: bar', 'bar: bazz'])
      end
    end

    describe '#assign_resource' do
      it 'should set assignments' do
        subject.assign_resource('foo', 'bar')
        subject.instance_variable_get(:@_assignments).should eq({foo: 'bar'})
      end
    end

    describe '#respond_with' do
      before { subject.stub!(:resource_name).and_return(:foo) }
      it 'calls Cyrax::Response' do
        Cyrax::Response.should_receive(:new).with(:foo, 'bar').and_return(mock.as_null_object)
        subject.respond_with('bar')
      end

      it 'should return Cyrax::Response instance' do
        subject.respond_with('bar').should be_a_kind_of(Cyrax::Response)
      end

      it 'should assign message, errors and additional assignments to response object' do
        response = mock
        Cyrax::Response.should_receive(:new).and_return(response)
        response.should_receive(:message=)
        response.should_receive(:errors=)
        response.should_receive(:assignments=)
        subject.respond_with('bar')
      end
    end
  end
end
