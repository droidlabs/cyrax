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

module DroidServices
  describe DroidServices::Extensions::HasDecorator do
    include DroidServices::Extensions::HasDecorator

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

      describe '#decorated_collection' do
        context 'when `decorable?`' do
          before { subject.stub!(:decorable?).and_return(true) }
          it 'should return decorated result' do
            subject.should_receive(:build_decorated_collection)
            subject.decorated_collection
          end
        end
        context 'when not `decorable?`' do
          before { subject.stub!(:decorable?).and_return(false) }
          it 'should return raw result' do
            subject.should_not_receive(:build_decorated_collection)
            subject.should_receive(:build_collection)
            subject.decorated_collection
          end
        end
      end

      describe '#build_decorated_collection' do
        before do
          self.class.decorator(:foo)
          subject.stub!(:prepare_collection_for_decorate).and_return([:bar])
        end

        it 'returns array of decorator instances' do
          subject.send(:build_decorated_collection).should eq([Foo.new(:bar)])
        end
      end

      describe '#prepare_collection_for_decorate' do
        subject { self.send(:prepare_collection_for_decorate) }

        context 'when #build_collection returns array' do
          before { self.stub!(:build_collection).and_return([:bar]) }
          it { should eq([:bar]) }
        end

        context 'when #build_collection returns any object except array' do
          before { self.stub!(:build_collection).and_return(:bar) }
          it { should eq([:bar]) }
        end

        context 'when #build_collection returns any object which responds to #all method' do
          let(:obj) { mock(:all => [:bar] ) }
          before { self.stub!(:build_collection).and_return(obj) }

          it { should eq([:bar]) }
        end
      end
    end
  end
end
