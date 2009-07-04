require File.dirname(__FILE__) + '/../test_helper.rb'

module CryptoProviderTest
  class Sha512Test < ActiveSupport::TestCase
    def test_encrypt
      assert ResourceAuthentication::CryptoProviders::Sha512.encrypt("mypass")
    end
    
    def test_matches
      hash = ResourceAuthentication::CryptoProviders::Sha512.encrypt("mypass")
      assert ResourceAuthentication::CryptoProviders::Sha512.matches?(hash, "mypass")
    end
  end
end