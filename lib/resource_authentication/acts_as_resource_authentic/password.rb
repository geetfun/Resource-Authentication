module ResourceAuthentication
  module ActsAsResourceAuthentic
    module Password
      def self.included(klass)
        klass.class_eval do
          extend Config
          add_acts_as_resource_authentic_module(Callbacks)
          add_acts_as_resource_authentic_module(Methods)
        end
      end
      
      module Config
        # The name of the crypted_password field in the remote API
        #
        # * <tt>Default:</tt> :crypted_password, :encrypted_password, :password_hash, or :pw_hash
        # * <tt>Accepts:</tt> Symbol
        def crypted_password_field(value = nil)
          config(:crypted_password_field, value, :crypted_password)
        end
        alias_method :crypted_password_field=, :crypted_password_field
        
        # The name of the password_salt field in the remote API
        #
        # * <tt>Default:</tt> :password_salt, :pw_salt, :salt, nil if none exist
        # * <tt>Accepts:</tt> Symbol
        def password_salt_field(value = nil)
          config(:password_salt_field, value, :password_salt)
        end
        alias_method :password_salt_field=, :password_salt_field
        
        # The class you want to use to encrypt and verify your encrypted passwords. 
        # The crypto provider modules were borrowed from Authlogic pretty much 100% 
        # See the ResourceAuthentication::CryptoProviders module for more info
        # on the available methods and how to create your own.
        #
        # * <tt>Default:</tt> CryptoProviders::Sha512
        # * <tt>Accepts:</tt> Class
        def crypto_provider(value = nil)
          config(:crypto_provider, value, CryptoProviders::Sha512)
        end
        alias_method :crypto_provider=, :crypto_provider
        
        # Whether or not to require a password confirmation. If you don't want your users to confirm their password
        # just set this to false.
        #
        # * <tt>Default:</tt> true
        # * <tt>Accepts:</tt> Boolean
        def require_password_confirmation(value = nil)
          config(:require_password_confirmation, value, true)
        end
        alias_method :require_password_confirmation=, :require_password_confirmation
        
        # By default passwords are required when a record is new or the crypted_password is blank, but if both of these things
        # are met a password is not required. In this case, blank passwords are ignored.
        #
        # Think about a profile page, where the user can edit all of their information, including changing their password.
        # If they do not want to change their password they just leave the fields blank. This will try to set the password to
        # a blank value, in which case is incorrect behavior. As such, Authlogic ignores this. But let's say you have a completely
        # separate page for resetting passwords, you might not want to ignore blank passwords. If this is the case for you, then
        # just set this value to false.
        #
        # * <tt>Default:</tt> true
        # * <tt>Accepts:</tt> Boolean
        def ignore_blank_passwords(value = nil)
          config(:ignore_blank_passwords, value, true)
        end
        alias_method :ignore_blank_passwords=, :ignore_blank_passwords
        
        # # Whether or not to validate the password field.
        # #
        # # * <tt>Default:</tt> true
        # # * <tt>Accepts:</tt> Boolean
        def validate_password_field(value = nil)
          config(:validate_password_field, value, true)
        end
        alias_method :validate_password_field=, :validate_password_field        
      end
      
      # Callbacks / hooks to allow other modules to modify the behavior of this module.
      module Callbacks
        METHODS = [
          "before_password_set", "after_password_set",
          "before_password_verification", "after_password_verification"
        ]
        
        def self.included(klass)
          return if klass.crypted_password_field.nil?
          klass.send :include, ActiveSupport::Callbacks unless klass.include? ActiveSupport::Callbacks
          klass.define_callbacks *METHODS
        end
        
        private
          METHODS.each do |method|
            class_eval <<-"end_eval", __FILE__, __LINE__
              def #{method}
                run_callbacks(:#{method}) { |result, object| result == false }
              end
            end_eval
          end
      end        
      # 
      # # The methods related to the password field.
      module Methods
        def self.included(klass)
          # return if klass.crypted_password_field.nil?
          
          klass.class_eval do
            include InstanceMethods
            
            if validate_password_field && !@validatable_set_for_password
              @validatable_set_for_password ||= true # Hack to ensure this is only run once during tests
              validates_length_of :password, :minimum => 6, :if => Proc.new {new_record? || password_changed? || send(crypted_password_field).blank?}
              # add validation for banned passwords, eg. password, qwerty, etc   
              if require_password_confirmation
                validates_confirmation_of :password, :if => Proc.new {new_record? || password_changed? || send(crypted_password_field).blank?}
              end
            end
            
      #       after_save :reset_password_changed
          end
        end
      #   
        module InstanceMethods
          # The password
          def password
            @password
          end
      #   
          # This is a virtual method. Once a password is passed to it, it will create new password salt as well as encrypt
          # the password.
          def password=(pass)
            return if ignore_blank_passwords? && pass.blank?
            before_password_set
            @password = pass
            
            send("#{password_salt_field}=", "some friendly token") if password_salt_field
            send("#{crypted_password_field}=", crypto_provider.encrypt(*encrypt_arguments(@password)))
            
            @password_changed = true
            after_password_set
          end
          
      #   
      #     # Accepts a raw password to determine if it is the correct password or not.
      #     def valid_password?(attempted_password)
      #       return false if attempted_password.blank? || send(crypted_password_field).blank?
      #     
      #       before_password_verification
      #     
      #       crypto_providers = [crypto_provider] + transition_from_crypto_providers
      #       crypto_providers.each_with_index do |encryptor, index|
      #         # The arguments_type of for the transitioning from restful_authentication
      #         arguments_type = (act_like_restful_authentication? && index == 0) ||
      #           (transition_from_restful_authentication? && index > 0 && encryptor == Authlogic::CryptoProviders::Sha1) ?
      #           :restful_authentication : nil
      #       
      #         if encryptor.matches?(send(crypted_password_field), *encrypt_arguments(attempted_password, arguments_type))
      #           # If we are transitioning from an older encryption algorithm and the password is still using the old algorithm
      #           # then let's reset the password using the new algorithm. If the algorithm has a cost (BCrypt) and the cost has changed, update the password with
      #           # the new cost.
      #           if index > 0 || (encryptor.respond_to?(:cost_matches?) && !encryptor.cost_matches?(send(crypted_password_field)))
      #             self.password = attempted_password
      #             save(false)
      #           end
      #         
      #           after_password_verification
      #         
      #           return true
      #         end
      #       end
      #     
      #       false
      #     end
      #   
      #     # Resets the password to a random friendly token.
      #     def reset_password
      #       friendly_token = Authlogic::Random.friendly_token
      #       self.password = friendly_token
      #       self.password_confirmation = friendly_token
      #     end
      #     alias_method :randomize_password, :reset_password
      #   
      #     # Resets the password to a random friendly token and then saves the record.
      #     def reset_password!
      #       reset_password
      #       save_without_session_maintenance(false)
      #     end
      #     alias_method :randomize_password!, :reset_password!
      #   
          private
            # no support is provided for RESTful auth plugin
            def encrypt_arguments(raw_password)
              salt = password_salt_field ? send(password_salt_field) : nil
              [raw_password, salt].compact
            end

            def require_password?
              new_record? || password_changed? || send(crypted_password_field).blank?
            end

            def ignore_blank_passwords?
              self.class.ignore_blank_passwords == true
            end
          
            def password_changed?
              @password_changed == true
            end
      #       
      #       def reset_password_changed
      #         @password_changed = nil
      #       end

            def crypted_password_field
              self.class.crypted_password_field
            end
          
            def password_salt_field
              self.class.password_salt_field
            end
            
            def crypto_provider
              self.class.crypto_provider
            end

        end
      end
    
    end
  end
end