require 'spec_helper'

class StrongParameters < Hash
  def permit(attrs)
    self.slice(*attrs)
  end
end

class Bar; end
class Foo; end

module Cyrax
  class BaseWithService < Cyrax::Base
    include Cyrax::Extensions::HasService
  end

  describe Cyrax::Extensions::HasResource do
    subject { BaseWithService.new }

    describe 'instance methods' do
      describe '#build_collection' do
        before { subject.stub(:resource_scope).and_return(Foo) }
        its(:build_collection) { should eq(Foo) }
      end

      describe '#find_resource' do
        let(:resource_scope) { double }
        before { subject.stub(:resource_scope).and_return(resource_scope) }
        it 'finds resource by id' do
          allow_message_expectations_on_nil
          resource_scope.should_receive(:find).with(123)
          subject.find_resource(123)
        end
      end

      describe '#build_resource' do
        context 'when id is nil' do
          let(:resource_scope) { double }
          before { subject.stub(:resource_scope).and_return(resource_scope) }
          before { subject.stub(:default_resource_attributes).and_return({}) }
          it 'initializes new object' do
            allow_message_expectations_on_nil
            resource_scope.should_receive(:new).with({foo: 'bar'})
            subject.build_resource(nil, {foo: 'bar'})
          end
        end
        context 'when id is present' do
          let(:resource) { double.as_null_object }
          it 'finds resource' do
            subject.should_receive(:find_resource).with(123).and_return(resource)
            subject.build_resource(123, {foo: 'bar'})
          end

          it 'assigns provided attributes' do
            subject.stub(:find_resource).and_return(resource)
            resource.should_receive(:attributes=).with({foo: 'bar'})
            subject.build_resource(123, {foo: 'bar'})
          end
        end
      end
    end
  end
end
