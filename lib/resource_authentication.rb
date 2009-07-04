# Resource-Authentication

require "active_support"

require File.dirname(__FILE__) + "/resource_authentication/version"

# require File.dirname(__FILE__) + "/resource_authentication/controller_adapters/abstract_adapter"
# require File.dirname(__FILE__) + "/resource_authentication/controller_adapters/rails_adapter" if defined?(Rails)
# require File.dirname(__FILE__) + "/authlogic/controller_adapters/merb_adapter" if defined?(Merb)

require File.dirname(__FILE__) + "/resource_authentication/acts_as_resource_authentic/email"
require File.dirname(__FILE__) + "/resource_authentication/acts_as_resource_authentic/base"