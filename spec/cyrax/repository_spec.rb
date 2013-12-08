require 'spec_helper'

class Foo; end
module Cyrax
  describe Repository do
    describe 'it should behave like repository' do
      context 'instance methods' do
        subject { Cyrax::Repository.new }
        it{ should respond_to(:resource_class) }
        it{ should respond_to(:scope) }
        it{ should respond_to(:build) }
        it{ should respond_to(:find_all) }
        it{ should respond_to(:find) }
        it{ should respond_to(:save) }
        it{ should respond_to(:delete) }
      end
    end

    describe 'instance methods' do
      describe '#find_all' do
        let(:scope) { double }
        before { subject.stub(:scope).and_return(scope) }
        it 'finds all objects by default' do
          scope.should_receive(:all)
          subject.find_all
        end
      end

      describe '#find_resource' do
        let(:scope) { double }
        before { subject.stub(:scope).and_return(scope) }
        it 'finds resource by id' do
          allow_message_expectations_on_nil
          scope.should_receive(:find).with(123)
          subject.find(123)
        end
      end

      describe '#build_resource' do
        context 'when id is nil' do
          let(:scope) { double }
          before { subject.stub(:scope).and_return(scope) }
          before { subject.stub(:default_attributes).and_return({}) }
          it 'initializes new object' do
            allow_message_expectations_on_nil
            scope.should_receive(:new).with({foo: 'bar'})
            subject.build(nil, {foo: 'bar'})
          end
        end
        context 'when id is present' do
          let(:resource) { double.as_null_object }
          it 'finds resource' do
            subject.should_receive(:find).with(123).and_return(resource)
            subject.build(123, {foo: 'bar'})
          end

          it 'assigns provided attributes' do
            subject.stub(:find).and_return(resource)
            resource.should_receive(:attributes=).with({foo: 'bar'})
            subject.build(123, {foo: 'bar'})
          end
        end
      end

      describe '#default_attributes' do
        it 'should return empty hash by default' do
          subject.send(:default_attributes).should eq({})
        end
      end
    end
  end
end