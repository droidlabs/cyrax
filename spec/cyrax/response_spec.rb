require 'spec_helper'

module Cyrax
  describe Response do
    subject { Cyrax::Response.new('some_resource', 'some_result')}

    describe '#with_message' do
      before { subject.with_message('some message') }
      it { should be_kind_of(Cyrax::Response) }
      its(:message) { should be }
      its(:message) { should eq('some message') }
    end

    describe '#with_errors' do
      before { subject.with_errors(['some', 'errors']) }
      it { should be_kind_of(Cyrax::Response) }
      its(:errors) { should be }
      its(:errors) { should eq(['some', 'errors']) }
    end

    describe '#success?' do
      context 'when there are no errors' do
        before { subject.with_errors([]) }
        its(:success?) { should be_true }
      end

      context 'when there are errors' do
        before { subject.with_errors(['some', 'errors']) }
        its(:success?) { should be_false }
      end
    end

    describe '#failure?' do
      context 'when there are no errors' do
        before { subject.with_errors([]) }
        its(:failure?) { should be_false }
      end

      context 'when there are errors' do
        before { subject.with_errors(['some', 'errors']) }
        its(:failure?) { should be_true }
      end
    end

    describe '#notice' do
      before { subject.with_message('some message') }
      context 'when there are no errors' do
        before { subject.with_errors([]) }
        its(:notice) { should be }
        its(:notice) { should eq('some message') }
      end

      context 'when there are errors' do
        before { subject.with_errors(['some', 'errors']) }
        its(:notice) { should be_nil }
      end
    end

    describe '#error' do
      context 'when there are no errors' do
        before { subject.with_errors([]) }
        its(:error) { should be_nil }
      end

      context 'when there are errors' do
        before { subject.with_errors(['some', 'message']) }
        its(:error) { should be }
        its(:error) { should eq('some') }
      end

      context 'when message is present' do
        before { subject.with_message('some message').with_errors(['some', 'message']) }
        its(:error) { should be }
        its(:error) { should eq('some message') }
      end
    end

    describe '#has_error?' do
      context 'when there are no errors' do
        before { subject.with_errors([]) }
        specify { subject.has_error?('foo').should be_false }
      end

      context 'when there are errors' do
        before { subject.with_errors(['some', 'message']) }
        specify { subject.has_error?('some').should be_true }
        specify { subject.has_error?('foo').should be_false }
      end
    end

    describe '#method_missing' do
      before { subject.assignments = {foo: 'bar'} }
      its(:foo) { should eq('bar') }
      specify { expect{ subject.bar }.to raise_error(NoMethodError) }
    end
  end
end
