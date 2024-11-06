# frozen_string_literal: true

require_relative '../test_helper'

class ConfigurationTest < Minitest::Test
  def test_default_domain
    config = ActiveRecord::ObscuredId::Configuration.new

    assert_equal 'example.com', config.domain
    assert_empty config.old_domains
  end

  def test_custom_domain
    config = ActiveRecord::ObscuredId::Configuration.new
    config.domain = 'custom.com'
    config.old_domains = ['old-custom.com']

    assert_equal 'custom.com', config.domain
    assert_equal ['old-custom.com'], config.old_domains
  end
end

class ObscuredIdTest < Minitest::Test
  def setup
    ActiveRecord::ObscuredId.config = ActiveRecord::ObscuredId::Configuration.new # Reset configuration before each test
  end

  def test_configure
    ActiveRecord::ObscuredId.configure do |config|
      config.domain = 'test.com'
      config.old_domains = ['old-test.com']
    end

    assert_equal 'test.com', ActiveRecord::ObscuredId.config.domain
    assert_equal ['old-test.com'], ActiveRecord::ObscuredId.config.old_domains
  end
end
