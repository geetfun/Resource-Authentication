class User < ActiveResource::Base
  include Validatable
  
  acts_as_resource_authentic

end