require 'spec_helper'

module Cyrax
  describe Decorator do
    let(:decorable) { double(foo:'bar') }
    subject { Cyrax::Decorator.new(decorable) }

    its(:resource) { should eq(decorable) }

    it 'should translate missing methods to decorable' do
      expect(subject.foo).to eq('bar')
    end

    it 'should not translate missing methods' do
      expect {
        subject.bar
      }.to raise_error(NoMethodError)
    end
  end
end
