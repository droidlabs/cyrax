require 'spec_helper'

class FooSerializer < Cyrax::Serializer
  attribute :name
  namespace :some do
    attributes :foo, :bar
  end
  relation :another do
    attributes :another_foo, :another_bar
  end
  relation :empty_relation_many do
    attributes :another_foo, :another_bar
  end
  relation :empty_relation_one do
    attributes :another_foo, :another_bar
  end
end

module Cyrax
  describe FooSerializer do
    let(:serializable) {
      double(
        name: 'me',
        foo: '2342',
        bar: '4223',
        another: double(another_foo: '1234', another_bar: '1234'),
        empty_relation_one: nil,
        empty_relation_many: []
      )
    }
    subject { FooSerializer.new(serializable).serialize }

    it 'should serialize object' do
      subject[:name].should eq('me')
      subject[:some][:foo].should eq('2342')
      subject[:another][:another_foo].should eq('1234')
      subject[:empty_relation_one].should eq(nil)
      subject[:empty_relation_many].should eq([])
    end
  end
end
