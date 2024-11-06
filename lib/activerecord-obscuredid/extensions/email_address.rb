# frozen_string_literal: true

require 'active_support/concern'
require 'active_support/core_ext/string/inflections' # for #pluralize, #underscore, #dasherize
require 'active_support/core_ext/string/filters' # for #remove

module ActiveRecord
  module ObscuredId
    module Extensions
      # Extension using obscured ID to generate email addresses that can be used
      # to find the record.
      module EmailAddress
        extend ActiveSupport::Concern

        class_methods do
          def from_obscured_email_address(obscured_email_address)
            domain = obscured_id_email_domain
            old_domains = obscured_id_email_old_domains
            subdomain = obscured_id_email_subdomain

            matched = obscured_email_address.match?(/@#{subdomain}.#{domain}\z/)
            matched ||= obscured_email_address.match?(/@#{subdomain}.(#{old_domains.join('|')})\z/) if old_domains.any?
            return nil unless matched

            find_obscured(obscured_email_address.remove(/@.*\z/))
          end

          private

          def obscured_id_email_domain = ActiveRecord::ObscuredId.config.domain
          def obscured_id_email_old_domains = ActiveRecord::ObscuredId.config.old_domains
          def obscured_id_email_subdomain = name.pluralize.underscore.dasherize.downcase
        end

        def obscured_email_address
          domain = self.class.send(:obscured_id_email_domain)
          subdomain = self.class.send(:obscured_id_email_subdomain)

          "#{obscured_id}@#{subdomain}.#{domain}"
        end
      end
    end
  end
end

if Object.const_defined?('ActiveRecord::Base')
  ActiveRecord::Base.include ActiveRecord::ObscuredId::Extensions::EmailAddress
end
