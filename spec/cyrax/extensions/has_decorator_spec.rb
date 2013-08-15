require 'spec_helper'

class Foo;
  attr_accessor :a
  def initialize(arg)
    @a = arg
  end

  def ==(other)
    self.a == other.a
  end
end

module Cyrax
  describe Cyrax::Extensions::HasDecorator do
    include Cyrax::Extensions::HasDecorator

    describe 'class attributes' do
      subject { self.class }
      it { should respond_to(:decorator_class_name) }
    end

    describe 'class methods' do
      describe '#decorator' do
        before { self.class.decorator(:foo) }
        subject { self }

        its(:decorator_class_name) { should eq('foo') }
      end
    end

    describe 'instance methods' do
      subject { self }

      describe '#decorator_class' do
        before { self.class.decorator(:foo) }
        its(:decorator_class) { should eq(Foo) }
      end

      describe '#decorable?' do
        context 'when `decorator_class_name` present' do
          before { self.class.decorator(:foo) }
          its(:decorable?) { should be_true }
        end

        context 'when `decorator_class_name` empty' do
          its(:decorable?) { should be_false }
        end
      end
    end
  end
end
