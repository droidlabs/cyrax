require 'spec_helper'

module Cyrax
  class BaseWithResponse < Cyrax::Base
    include Cyrax::Extensions::HasResponse
  end

  describe Cyrax::Extensions::HasResponse do
    subject { BaseWithResponse.new }
    before do
      allow(subject).to receive(:decorable?).and_return(false)
      allow(subject).to receive(:decorator_class).and_return(nil)
    end

    describe '#set_message' do
      it 'should set message' do
        subject.set_message('foo')
        expect(subject.instance_variable_get(:@_message)).to eq('foo')
      end
    end

    describe '#add_error' do
      it 'should add error' do
        subject.add_error(:foo, 'bar')
        expect(subject.instance_variable_get(:@_errors).has_key?(:foo)).to be(true)
      end
    end

    describe '#add_error_unless' do
      it 'should add error when condition false' do
        subject.add_error_unless(:foo, 'bar', 1==0)
        expect(subject.instance_variable_get(:@_errors).has_key?(:foo)).to be(true)
      end

      it 'should not add error when condition true' do
        subject.add_error_unless(:foo, 'bar', 1==1)
        expect(subject.instance_variable_get(:@_errors)).to be_nil
      end
    end

    describe '#sync_errors_with' do
      let(:messages) { [[:foo, 'bar'], [:bar, 'bazz']]}
      let(:errors) { double(messages: messages)}
      let(:model) { double(errors: errors) }

      it 'should add errors from model error messages' do
        subject.sync_errors_with(model)
        expect(subject.instance_variable_get(:@_errors)).to eq({foo: 'bar', bar: 'bazz'})
      end
    end

    describe '#assign_resource' do
      it 'should set assignments' do
        subject.assign_resource('foo', 'bar')
        expect(subject.instance_variable_get(:@_assignments)).to eq({foo: 'bar'})
      end
    end

    describe '#respond_with' do
      before { allow(subject).to receive(:response_name).and_return(:foo) }
      it 'calls Cyrax::Response' do
        expect(Cyrax::Response).to receive(:new).with(:foo, 'bar', {as: nil, assignments: nil}).and_return(double.as_null_object)
        subject.respond_with('bar')
      end

      it 'should return Cyrax::Response instance' do
        expect(subject.respond_with('bar')).to be_a_kind_of(Cyrax::Response)
      end

      it 'should assign message, errors and additional assignments to response object' do
        response = double
        expect(Cyrax::Response).to receive(:new).and_return(response)
        expect(response).to receive(:message=)
        expect(response).to receive(:errors=)
        expect(response).to receive(:assignments=)
        expect(response).to receive(:status=)
        subject.respond_with('bar')
      end
    end
  end
end
