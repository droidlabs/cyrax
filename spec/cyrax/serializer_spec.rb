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
      expect(subject[:name]).to eq('me')
      expect(subject[:some][:foo]).to eq('2342')
      expect(subject[:another][:another_foo]).to eq('1234')
      expect(subject[:empty_relation_one]).to eq(nil)
      expect(subject[:empty_relation_many]).to eq([])
    end
  end
end
