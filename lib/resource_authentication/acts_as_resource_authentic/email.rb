module ResourceAuthentication
  module ActsAsResourceAuthentic
    module Email
      def self.included(klass)
        klass.class_eval do
          extend Config
          add_acts_as_resource_authentic_module(Methods)
        end
      end
      
      module Config
        # The name of the field that stores email addresses.
        #
        # * <tt>Default:</tt> :email, if it exists
        # * <tt>Accepts:</tt> Symbol
        def email_field(value = nil)
          config(:email_field, value, :email)
        end
        alias_method :email_field=, :email_field
        
        # Toggles validating the email field or not.
        #
        # * <tt>Default:</tt> true
        # * <tt>Accepts:</tt> Boolean
        def validate_email_field(value = nil)
          config(:validate_email_field, value, true)
        end
        alias_method :validate_email_field=, :validate_email_field
        
        # A hash of options for the validates_length_of call for the email field. Allows you to change this however you want.
        #
        # * <tt>Default:</tt> {:within => 6..100}
        # * <tt>Accepts:</tt> Hash of options accepted by validates_length_of
        def validates_length_of_email_field_options(value = nil)
          config(:validates_length_of_email_field_options, value, {:within => 6..100})
        end
        alias_method :validates_length_of_email_field_options=, :validates_length_of_email_field_options
        
        # A hash of options for the validates_format_of call for the email field. Allows you to change this however you want.
        #
        # * <tt>Default:</tt> {:with => email_regex, :message => I18n.t('error_messages.email_invalid', :default => "should look like an email address.")}
        # * <tt>Accepts:</tt> Hash of options accepted by validates_format_of
        def validates_format_of_email_field_options(value = nil)
          config(:validates_format_of_email_field_options, value, {:with => email_regex, :message => I18n.t('error_messages.email_invalid', :default => "should look like an email address.")})
        end
        alias_method :validates_format_of_email_field_options=, :validates_format_of_email_field_options
        
        private
          def email_regex
            return @email_regex if @email_regex
            email_name_regex  = '[\w\.%\+\-]+'
            domain_head_regex = '(?:[A-Z0-9\-]+\.)+'
            domain_tld_regex  = '(?:[A-Z]{2,4}|museum|travel)'
            @email_regex = /\A#{email_name_regex}@#{domain_head_regex}#{domain_tld_regex}\z/i
          end
      end
      
      module Methods
        def self.included(klass)
          klass.class_eval do
            if validate_email_field && email_field && !@validatable_set_for_email
              @validatable_set_for_email ||= true # Hack to ensure this is only run once during tests
              validates_length_of email_field, validates_length_of_email_field_options
              validates_format_of email_field, validates_format_of_email_field_options
            end
          end
        end
      end
      
    end
  end
end