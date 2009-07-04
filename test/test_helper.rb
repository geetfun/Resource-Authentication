require 'rubygems'
require 'test/unit'
require 'active_support'
require 'active_support/test_case'
require 'activeresource'
require 'active_resource/http_mock'
require 'shoulda'
require 'factory_girl'
require File.dirname(__FILE__) + '/../lib/resource_authentication' unless defined?(ResourceAuthentication)

class User < ActiveResource::Base
  acts_as_resource_authentic
end