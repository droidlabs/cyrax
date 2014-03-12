require 'spec_helper'

module Cyrax
  class BaseWithResponse < Cyrax::Base
    include Cyrax::Extensions::HasResponse
  end

  describe Cyrax::Extensions::HasResponse do
    subject { BaseWithResponse.new }
    before do
      subject.stub(:decorable?).and_return(false)
      subject.stub(:decorator_class).and_return(nil)
    end

    describe '#set_message' do
      it 'should set message' do
        subject.set_message('foo')
        subject.instance_variable_get(:@_message).should eq('foo')
      end
    end

    describe '#add_error' do
      it 'should add error' do
        subject.add_error(:foo, 'bar')
        subject.instance_variable_get(:@_errors).has_key?(:foo).should be_true
      end
    end

    describe '#add_error_unless' do
      it 'should add error when condition false' do
        subject.add_error_unless(:foo, 'bar', 1==0)
        subject.instance_variable_get(:@_errors).has_key?(:foo).should be_true
      end

      it 'should not add error when condition true' do
        subject.add_error_unless(:foo, 'bar', 1==1)
        subject.instance_variable_get(:@_errors).should be_nil
      end
    end

    describe '#sync_errors_with' do
      let(:messages) { [[:foo, 'bar'], [:bar, 'bazz']]}
      let(:errors) { double(messages: messages)}
      let(:model) { double(errors: errors) }

      it 'should add errors from model error messages' do
        subject.sync_errors_with(model)
        subject.instance_variable_get(:@_errors).should eq({foo: 'bar', bar: 'bazz'})
      end
    end

    describe '#assign_resource' do
      it 'should set assignments' do
        subject.assign_resource('foo', 'bar')
        subject.instance_variable_get(:@_assignments).should eq({foo: 'bar'})
      end
    end

    describe '#respond_with' do
      before { subject.stub(:response_name).and_return(:foo) }
      it 'calls Cyrax::Response' do
        Cyrax::Response.should_receive(:new).with(:foo, 'bar', {as: nil, assignments: nil}).and_return(double.as_null_object)
        subject.respond_with('bar')
      end

      it 'should return Cyrax::Response instance' do
        subject.respond_with('bar').should be_a_kind_of(Cyrax::Response)
      end

      it 'should assign message, errors and additional assignments to response object' do
        response = double
        Cyrax::Response.should_receive(:new).and_return(response)
        response.should_receive(:message=)
        response.should_receive(:errors=)
        response.should_receive(:assignments=)
        response.should_receive(:status=)
        subject.respond_with('bar')
      end
    end
  end
end
