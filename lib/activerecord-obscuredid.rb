# frozen_string_literal: true

require 'activerecord-obscuredid/base32'
require 'activerecord-obscuredid/configuration'
require 'activerecord-obscuredid/extensions/email_address'

require 'active_support/concern'

module ActiveRecord
  # = Active Record Obscured Id
  module ObscuredId
    extend ActiveSupport::Concern

    # Class methods
    module ClassMethods
      # Finds a record by its obscured ID.
      #
      # This method decodes the given obscured ID to extract the original record ID,
      # then searches for the record using the decoded ID.
      #
      # @param obscured_id [String] The obscured ID that represents the original record ID.
      # @return [ActiveRecord::Base, nil] Returns the record if found, otherwise returns `nil`.
      #
      # @example
      #   user = User.find_obscured('g4ztomi') # => <User:0x0000000165a73210 id: 7371, ...>
      #   # Returns the user with ID 7371 corresponding to the decoded value of "g4ztomi"
      def find_obscured(obscured_id)
        find_by(id: decode_obscured_id(obscured_id))
      end

      # Same as #find_obscured but will raise +ActiveRecord::RecordNotFound+
      # exception if the decoded id can't find a record.
      def find_obscured!(obscured_id)
        find(decode_obscured_id(obscured_id))
      end

      private

      def decode_obscured_id(obscured_id)
        Base32.decode(obscured_id.upcase)
      end
    end

    # Generates an obscured representation of the record's ID.
    #
    # This method encodes the ID of the current record using a Base32 encoding
    # scheme. The resulting obscured ID is a down-cased string that does not
    # directly reveal the actual ID, making it suitable for public references
    # (e.g., in URLs or emails). It is case-insensitive making it ideal for use
    # cases like constructing email addresses or URLs, where case sensitivity
    # might be an issue.
    #
    # @return [String] A down-cased Base32-encoded string representing the record's ID.
    #
    # @example
    #   user = User.find(7371)
    #   user.obscured_id
    #   # => "g4ztomi" (an example Base32 encoded version of the ID)
    def obscured_id = Base32.encode(id.to_s).downcase
  end
end

ActiveRecord::Base.include ActiveRecord::ObscuredId if Object.const_defined?('ActiveRecord::Base')
