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
  class BaseWithDecorator < Cyrax::Base
    include Cyrax::Extensions::HasDecorator
  end

  describe Cyrax::Extensions::HasDecorator do
    subject { BaseWithDecorator.new }

    describe 'class attributes' do
      its(:class) { should respond_to(:decorator_class_name) }
    end

    describe 'class methods' do
      describe '#decorator' do
        before { subject.class.decorator(:foo) }

        its(:decorator_class_name) { should eq('foo') }
      end
    end

    describe 'instance methods' do
      describe '#decorator_class' do
        before { subject.class.decorator(:foo) }
        its(:decorator_class) { should eq(Foo) }
      end

      describe '#decorable?' do
        context 'when `decorator_class_name` present' do
          before { subject.class.decorator(:foo) }
          its(:decorable?) { should be_true }
        end

        context 'when `decorator_class_name` empty' do
          before { subject.class.decorator(nil) }
          its(:decorable?) { should be_false }
        end
      end
    end
  end
end
