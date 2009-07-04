module ResourceAuthentication
  module ActsAsResourceAuthentic
    module Base
      def self.included(klass)
        klass.class_eval do
          extend Config
        end
      end
      
      module Config
        def acts_as_resource_authentic(&block)
          yield self if block_given?
          acts_as_resource_authentic_modules.each { |mod| include mod }
        end
        
        def add_acts_as_resource_authentic_module(mod, action = :append)
          modules = acts_as_resource_authentic_modules
          case action
          when :append
            modules << mod
          when :prepend
            modules = [mod] + modules
          end
          modules.uniq!
          write_inheritable_attribute(:acts_as_resource_authentic_modules, modules)
        end
        
        def remove_acts_as_resource_authentic_module(mod)
          acts_as_resource_authentic_modules.delete(mod)
          acts_as_resource_authentic_modules
        end
        
        private
        
          def acts_as_resource_authentic_modules
            key = :acts_as_resource_authentic_modules
            inheritable_attributes.include?(key) ? read_inheritable_attribute(key) : []
          end
          
          def config(key, value, default_value = nil, read_value = nil)
            if value == read_value
              inheritable_attributes.include?(key) ? read_inheritable_attribute(key) : default_value
            else
              write_inheritable_attribute(key, value)
            end
         end          
      end
    end
  end
end

if defined?(::ActiveResource)
  module ::ActiveResource
    class Base
      include ResourceAuthentication::ActsAsResourceAuthentic::Base
      include ResourceAuthentication::ActsAsResourceAuthentic::Email
      include ResourceAuthentication::ActsAsResourceAuthentic::Password
    end
  end
end