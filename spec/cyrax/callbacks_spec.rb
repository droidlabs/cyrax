require 'spec_helper'

module Cyrax
  describe Callbacks do
    subject { Cyrax::Callbacks.new(mock) }

    it { should respond_to(:before_create) }
    it { should respond_to(:after_create) }

    it { should respond_to(:before_save) }
    it { should respond_to(:after_save) }

    it { should respond_to(:before_update) }
    it { should respond_to(:after_update) }

    it { should respond_to(:before_destroy) }
    it { should respond_to(:after_destroy) }
  end
end
