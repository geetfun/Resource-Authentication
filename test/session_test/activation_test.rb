require File.dirname(__FILE__) + '/../test_helper.rb'

module SessionTest
  module ActivationTest
    class ClassMethodsTest < ActiveSupport::TestCase
      context "activation" do
        should "be activated" do
          assert UserSession.activated?
        end
        
        should "not be activated" do
          ResourceAuthentication::Session::Base.controller = nil
          assert !UserSession.activated?
        end
      end
      
      context "testing controller" do
        should "be threadsafe" do
          ResourceAuthentication::Session::Base.controller = nil
          assert_nil ResourceAuthentication::Session::Base.controller
          
          thread1 = Thread.new do
            controller = MockController.new
            ResourceAuthentication::Session::Base.controller = controller
            assert_equal controller, ResourceAuthentication::Session::Base.controller
          end
          thread1.join
          
          assert_nil ResourceAuthentication::Session::Base.controller
          
          thread2 = Thread.new do
            controller = MockController.new
            ResourceAuthentication::Session::Base.controller = controller
            assert_equal controller, ResourceAuthentication::Session::Base.controller
          end
          thread2.join
          
          assert_nil ResourceAuthentication::Session::Base.controller
        end
      end
    end
    
    class InstanceMethodsTest < ActiveSupport::TestCase
      should "initialize" do
        UserSession.controller = nil
        assert_raise(ResourceAuthentication::Session::Activation::NotActivatedError) { UserSession.new }
        # UserSession.controller = controller
      end
    end
  end
end