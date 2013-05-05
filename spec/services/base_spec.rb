require 'spec_helper'

module DroidServices
  describe Base do
    describe '#new' do
      subject { DroidServices::Base.new({as: :john, params: {foo: 'bar'}})}
      its(:accessor) { should eq(:john) }
      its(:params) { should eq({foo: 'bar'}) }
    end
  end
end
