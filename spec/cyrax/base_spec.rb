require 'spec_helper'

module Cyrax
  describe Base do
    describe '#new' do
      subject { Cyrax::Base.new({as: :john, params: {foo: 'bar'}})}
      its(:accessor) { should eq(:john) }
      its(:params) { should eq({foo: 'bar'}) }
    end
  end
end
