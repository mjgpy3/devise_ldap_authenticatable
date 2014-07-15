require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class LdapAuthenticatable < Authenticatable
      def authenticate!
        Rails.logger.error "#{authentication_hash.inspect}"
        resource = mapping.to.find_for_ldap_authentication(authentication_hash.merge(password: password))
        
        if resource && validate(resource) { resource.valid_ldap_authentication?(password) }
          resource.after_ldap_authentication
          success!(resource)
        else
          return fail(:invalid)
        end


      end
    end
  end
end

Warden::Strategies.add(:ldap_authenticatable, Devise::Strategies::LdapAuthenticatable)
