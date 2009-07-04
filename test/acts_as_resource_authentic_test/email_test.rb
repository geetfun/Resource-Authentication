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
      
      should "validate length of email field" do
        u = User.new
        u.email = "a@a.a"
        assert !u.valid?
        assert u.errors.on(:email)
        
        u.email = "skhchiu@gmail.com"
        assert u.valid?
        assert !u.errors.on(:email)
      end
      
      should "validate format of email field" do
        u = User.new
        u.email = "aaaaaaaaaaaaa"
        assert !u.valid?
        assert u.errors.on(:email)

        u.email = "skhchiu@gmail.com"
        assert u.valid?
        assert !u.errors.on(:email)
      end
    end
  end
end