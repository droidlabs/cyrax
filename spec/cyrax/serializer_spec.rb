require 'spec_helper'

class FooSerializer < Cyrax::Serializer
  attribute :name
  namespace :some do
    attributes :foo, :bar
  end
end

module Cyrax
  describe FooSerializer do
    let(:serializable) { double(name: 'me', some: double(foo: '1234', bar: '1234')) }
    subject { FooSerializer.new(serializable).serialize }

    it 'should serialize object' do
      subject[:name].should eq('me')
      subject[:some][:foo].should eq('1234')
    end
  end
end
