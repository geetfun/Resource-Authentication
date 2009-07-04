require File.dirname(__FILE__) + '/../test_helper.rb'

module CryptoProviderTest
  class BCrpytTest < ActiveSupport::TestCase
    def test_encrypt
      assert ResourceAuthentication::CryptoProviders::BCrypt.encrypt("mypass")
    end
    
    def test_matches
      hash = ResourceAuthentication::CryptoProviders::BCrypt.encrypt("mypass")
      assert ResourceAuthentication::CryptoProviders::BCrypt.matches?(hash, "mypass")
    end
  end
end