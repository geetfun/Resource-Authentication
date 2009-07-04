# Resource-Authentication

require "active_support"

require File.dirname(__FILE__) + "/resource_authentication/version"

# require File.dirname(__FILE__) + "/resource_authentication/controller_adapters/abstract_adapter"
# require File.dirname(__FILE__) + "/resource_authentication/controller_adapters/rails_adapter" if defined?(Rails)
# require File.dirname(__FILE__) + "/authlogic/controller_adapters/merb_adapter" if defined?(Merb)

require File.dirname(__FILE__) + "/resource_authentication/crypto_providers/md5"
require File.dirname(__FILE__) + "/resource_authentication/crypto_providers/sha1"
require File.dirname(__FILE__) + "/resource_authentication/crypto_providers/sha512"
require File.dirname(__FILE__) + "/resource_authentication/crypto_providers/bcrypt"
require File.dirname(__FILE__) + "/resource_authentication/crypto_providers/aes256"

require File.dirname(__FILE__) + "/resource_authentication/acts_as_resource_authentic/password"
require File.dirname(__FILE__) + "/resource_authentication/acts_as_resource_authentic/email"
require File.dirname(__FILE__) + "/resource_authentication/acts_as_resource_authentic/base"