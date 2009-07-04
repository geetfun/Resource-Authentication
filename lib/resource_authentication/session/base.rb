module ResourceAuthentication
  module Session
    # This is the base class ResourceAuthentication, where all modules are included. For information on functiionality see the various
    # sub modules.
    class Base
      include Activation
    end
  end
end