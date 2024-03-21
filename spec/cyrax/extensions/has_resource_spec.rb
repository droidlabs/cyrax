require 'spec_helper'

class StrongParameters < Hash
  def permit(attrs)
    self.slice(*attrs)
  end
end

class Bar; end
class Foo; end

module Cyrax
  class BaseWithResource < Cyrax::Base
    include Cyrax::Extensions::HasResource
  end

  describe Cyrax::Extensions::HasResource do
    subject { BaseWithResource.new }

    describe 'class attributes' do
      its(:class) { should respond_to(:resource_name) }
      its(:class) { should respond_to(:resource_class_name) }
    end

    describe 'class methods' do
      describe '#resource' do
        before { subject.class.resource(:foo, class_name:'bar', name:'bazz') }

        its(:resource_name) { should eq('foo') }
        its(:resource_class_name) { should eq('bar') }
      end
    end

    describe 'instance methods' do

      describe '#resource_name' do
        before { subject.class.resource(:foo) }
        its(:resource_name) { should eq('foo') }
      end

      describe '#collection_name' do
        before { subject.class.resource(:foo) }
        its(:collection_name) { should eq('foos') }
      end

      describe '#resource_class' do
        context 'when `class_name` option is supplied' do
          before { subject.class.resource(:foo, class_name:'Bar') }
          its(:resource_class) { should eq(Bar) }
        end

        context 'when `class_name` option is omited' do
          before { subject.class.resource(:foo) }
          its(:resource_class) { should eq(Foo) }
        end
      end

      describe '#resource_scope' do
        before { allow(subject).to receive(:resource_class).and_return(Foo) }
        its(:resource_scope) { should eq(Foo) }
      end

      describe '#resource_attributes' do
        let(:dirty_resource_attributes) { double }
        before { allow(subject).to receive(:dirty_resource_attributes).and_return(dirty_resource_attributes)}
        it 'filters dirty attributes' do
          expect(subject).to receive(:filter_attributes).with(dirty_resource_attributes)
          subject.resource_attributes
        end
      end
    end

    describe 'private methods' do
      before { Cyrax.strong_parameters = false }
      describe '#dirty_resource_attributes' do
        context 'when params are present' do
          it 'should return from params by resource_name' do
            allow(subject).to receive(:resource_name).and_return(:foo)
            allow(subject).to receive(:params).and_return({foo: {bar: 'bazz'}})
            expect(subject.send(:dirty_resource_attributes)).to eq({bar: 'bazz'})
          end
        end
        context 'when there are no params' do
          it 'should return empty hash' do
            allow(subject).to receive(:resource_name).and_return(:foo)
            allow(subject).to receive(:params).and_return({})
            expect(subject.send(:dirty_resource_attributes)).to eq({})
          end
        end
      end
      describe '#default_resource_attributes' do
        it 'should return empty hash by default' do
          expect(subject.send(:default_resource_attributes)).to eq({})
        end
      end

      describe '#filter_attributes' do
        it 'should return supplied attributes by default' do
          expect(subject.send(:filter_attributes, {foo: 'bar'})).to eq({foo: 'bar'})
        end
        it 'should return blank attributes by default for strong_paramters=true' do
          Cyrax.strong_parameters = true
          params =  StrongParameters.new(foo: 'bar')
          expect(subject.send(:filter_attributes, params)).to eq({})
        end
      end
    end
  end
end
