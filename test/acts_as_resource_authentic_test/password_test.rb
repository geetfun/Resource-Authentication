require File.dirname(__FILE__) + '/../test_helper.rb'

module ActsAsResourceAuthenticTest
  class PasswordTest < ActiveSupport::TestCase
    context "password configuration" do
      should "have a defined crypted password field" do
        assert_equal :crypted_password, User.crypted_password_field
        
        User.crypted_password_field = :encrypted_password
        assert_equal :encrypted_password, User.crypted_password_field
        
        User.crypted_password_field = :crypted_password
        assert_equal :crypted_password, User.crypted_password_field
      end
      
      should "have defined field for requiring / not requiring password" do
        assert_equal true, User.require_password_confirmation # default value
        
        User.require_password_confirmation = false
        assert_equal false, User.require_password_confirmation
        
        User.require_password_confirmation = true
        assert_equal true, User.require_password_confirmation        
      end
      
      should "have a defined field for ignoring / not ignoring blank password" do
        assert_equal true, User.ignore_blank_passwords # default value
        
        User.ignore_blank_passwords = false
        assert_equal false, User.ignore_blank_passwords
        
        User.ignore_blank_passwords = true
        assert_equal true, User.ignore_blank_passwords
      end
      
      should "have a defined field for validating / not validating passwords" do
        assert_equal true, User.validate_password_field # default value
        
        User.validate_password_field = false
        assert_equal false, User.validate_password_field
        
        User.validate_password_field = true
        assert_equal true, User.validate_password_field
      end
    end
    
    context "password methods" do
      context "changing passwords" do
        setup do
          @user = User.new
          @user.email = 'someperson@email.com'
        end
        
        should "be able to assign password" do
          @user.password = "123moose"
          assert_equal "123moose", @user.password
        end
        
        should "be able to assign password_confirmation" do
          @user.password_confirmation = "123moose"
          assert_equal "123moose", @user.password_confirmation
        end
        
        should "have matching password and password_confirmation" do
          @user.password = "123moose"
          @user.password_confirmation = "123moose".reverse
          
          assert_not_equal @user.password, @user.password_confirmation
          assert !@user.valid?
          
          @user.password_confirmation = "123moose"
          assert_equal @user.password, @user.password_confirmation
          assert @user.valid?
        end
        
        should "have a password length of at least 6 (by default)" do
          @user.password = "12345"
          @user.password_confirmation = "12345"
          assert !@user.valid?
          
          @user.password = "123456"
          @user.password_confirmation = "123456"
          assert @user.valid?
        end
      end
    end    
  end
end