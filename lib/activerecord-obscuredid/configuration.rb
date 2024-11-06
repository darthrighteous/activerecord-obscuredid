# frozen_string_literal: true

module ActiveRecord
  # = Active Record Obscured Id
  module ObscuredId
    # Holds configuration options for obscured id
    class Configuration
      attr_accessor :domain, :old_domains

      def initialize
        @domain = 'example.com'
        @old_domains = []
      end
    end

    class << self
      attr_writer :config

      def config
        @config ||= Configuration.new
      end

      def configure
        yield(config)
      end
    end
  end
end
