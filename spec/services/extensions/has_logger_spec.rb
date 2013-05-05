require 'spec_helper'

module DroidServices
  describe DroidServices::Extensions::HasLogger do
    include DroidServices::Extensions::HasLogger

    before { self.class.stub!(:rails_log_path).and_return('./log') }

    describe '#logger' do
      it { logger.should be_kind_of(Yell::Logger) }
    end

    describe '#format_message' do
      context 'when String' do
        let(:message) { 'Some test' }
        it { format_message(message).should be_kind_of(String) }
        it { format_message(message).should eq('Some test')}
      end

      context 'when Hash' do
        let(:message) { {'dog' => 'canine', 'cat' => 'feline', 12 => 'number', user: {nick: 'Guru', 'name' => 'User'}} }
        it { format_message(message).should be_kind_of(String) }
        it { format_message(message).should eq("{\n  \"dog\": \"canine\",\n  \"cat\": \"feline\",\n  \"12\": \"number\",\n  \"user\": {\n    \"nick\": \"Guru\",\n    \"name\": \"User\"\n  }\n}") }
      end

      context 'when Array' do
        let(:message) { ['dog', 'cat', 'number'] }
        it { format_message(message).should be_kind_of(String) }
        it { format_message(message).should eq("[\n  \"dog\",\n  \"cat\",\n  \"number\"\n]") }
      end

      context 'when some object' do
        let(:message) { mock }
        it 'should inspect object' do
          message.should_receive(:inspect)
          format_message(message)
        end
      end
    end
  end
end
