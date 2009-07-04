require 'rubygems'
require 'test/unit'
require 'active_support'
require 'active_support/test_case'
require 'activeresource'
require 'active_resource/http_mock'
require 'shoulda'
require 'factory_girl'
require 'validatable'
require File.dirname(__FILE__) + '/../lib/resource_authentication' unless defined?(ResourceAuthentication)
require File.dirname(__FILE__) + '/../lib/resource_authentication/test_case'
require File.dirname(__FILE__) + '/libs/user'
require File.dirname(__FILE__) + '/libs/user_session'

ResourceAuthentication::CryptoProviders::AES256.key = "myafdsfddddddddddddddddddddddddddddddddddddddddddddddd"

class ActiveSupport::TestCase
  # include ActiveRecord::TestFixtures
  # self.fixture_path = File.dirname(__FILE__) + "/fixtures"
  # self.use_transactional_fixtures = false
  # self.use_instantiated_fixtures  = false
  # self.pre_loaded_fixtures = false
  # fixtures :all
  setup :activate_authlogic
  
  private
    def password_for(user)
      case user
      when users(:ben)
        "benrocks"
      when users(:zack)
        "zackrocks"
      end
    end
    
    def http_basic_auth_for(user = nil, &block)
      unless user.blank?
        controller.http_user = user.login
        controller.http_password = password_for(user)
      end
      yield
      controller.http_user = controller.http_password = nil
    end
    
    def set_cookie_for(user, id = nil)
      controller.cookies["user_credentials"] = {:value => user.persistence_token, :expires => nil}
    end
    
    def unset_cookie
      controller.cookies["user_credentials"] = nil
    end
    
    def set_params_for(user, id = nil)
      controller.params["user_credentials"] = user.single_access_token
    end
    
    def unset_params
      controller.params["user_credentials"] = nil
    end
    
    def set_request_content_type(type)
      controller.request_content_type = type
    end
    
    def unset_request_content_type
      controller.request_content_type = nil
    end
    
    def set_session_for(user, id = nil)
      controller.session["user_credentials"] = user.persistence_token
      controller.session["user_credentials_id"] = user.id
    end
    
    def unset_session
      controller.session["user_credentials"] = controller.session["user_credentials_id"] = nil
    end
end