require 'spec_helper'

class StrongParameters < Hash
  def permit(attrs)
    self.slice(*attrs)
  end
end

class Bar; end
class Foo; end

module Cyrax
  class BaseWithService < Cyrax::Base
    include Cyrax::Extensions::HasService
  end

  describe Cyrax::Extensions::HasResource do
    subject { BaseWithService.new }
  end
end
