require 'spec_helper'

module DroidServices
  describe Decorator do
    let(:decorable) { mock(foo:'bar') }
    subject { DroidServices::Decorator.new(decorable) }

    its(:resource) { should eq(decorable) }

    it 'should translate missing methods to decorable' do
      subject.foo.should eq('bar')
    end

    it 'should not translate missing methods' do
      expect {
        subject.bar
      }.to raise_error(NoMethodError)
    end
  end
end
