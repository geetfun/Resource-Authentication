require File.dirname(__FILE__) + '/../test_helper.rb'

module ActsAsResourceAuthenticTest
  class BaseTest < ActiveSupport::TestCase
    context "invoking acts_as_resource_authentic" do
      should "raise nothing" do
        assert_nothing_raised do
          User.acts_as_resource_authentic do
          end
        end
      end
    end
  end
end