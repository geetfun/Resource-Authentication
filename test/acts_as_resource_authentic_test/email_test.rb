require File.dirname(__FILE__) + '/../test_helper.rb'

module ActsAsResourceAuthenticTest
  class EmailTest < ActiveSupport::TestCase
    context "email configurations" do
      should "have defined email fields" do
        assert_equal :email, User.email_field
        
        User.email_field = :nope
        assert_equal :nope, User.email_field
        
        User.email_field :email
        assert_equal :email, User.email_field
      end
      
      should "have defined validation for email fields" do
        assert User.validate_email_field
        
        User.validate_email_field = false
        assert !User.validate_email_field
        
        User.validate_email_field = true
        assert User.validate_email_field
      end
      
      should "have defined validation for email length" do
        assert_equal({:within => 6..100}, User.validates_length_of_email_field_options)

        User.validates_length_of_email_field_options = {:yes => "no"}
        assert_equal({:yes => "no"}, User.validates_length_of_email_field_options)
        User.validates_length_of_email_field_options({:within => 6..100})
        assert_equal({:within => 6..100}, User.validates_length_of_email_field_options)        
      end
      
      should "have defined validation for email format" do
        default = {:with => User.send(:email_regex), :message => I18n.t('error_messages.email_invalid', :default => "should look like an email address.")}
        assert_equal default, User.validates_format_of_email_field_options

        User.validates_format_of_email_field_options = {:yes => "no"}
        assert_equal({:yes => "no"}, User.validates_format_of_email_field_options)
        User.validates_format_of_email_field_options default
        assert_equal default, User.validates_format_of_email_field_options
      end
      
      context "validating email" do 
        setup do
          @user = User.new
          @user.password = 'somepassword'
          @user.password_confirmation = 'somepassword'
        end
        
        should "validate length of email field" do
          @user.email = "a@a.a"
          assert !@user.valid?
          assert @user.errors.on(:email)
        
          @user.email = "skhchiu@gmail.com"
          assert @user.valid?
          assert !@user.errors.on(:email)
        end
      
        should "validate format of email field" do
          @user.email = "aaaaaaaaaaaaa"
          assert !@user.valid?
          assert @user.errors.on(:email)

          @user.email = "skhchiu@gmail.com"
          assert @user.valid?
          assert !@user.errors.on(:email)
        end
      end
    end
  end
end