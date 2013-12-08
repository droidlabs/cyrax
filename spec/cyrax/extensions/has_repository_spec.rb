require 'spec_helper'

class Bar; end
class Foo; end

module Cyrax
  class BaseWithRepository < Cyrax::Base
    include Cyrax::Extensions::HasRepository
  end

  describe Cyrax::Extensions::HasRepository do
    subject { BaseWithRepository.new }

    describe 'class attributes' do
      its(:class) { should respond_to(:_repository_class) }
    end

    describe 'class methods' do
      describe '#repository' do
        context "define repository class" do
          before { subject.class.repository(Foo) }
          
          its(:repository_class) { should eq(Foo) }
        end
      end
    end
  end
end