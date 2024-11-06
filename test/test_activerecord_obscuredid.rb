# frozen_string_literal: true

require 'test_helper'

# Mock User class for testing purposes
class MockRecord
  include ActiveRecord::ObscuredId
  include ActiveRecord::ObscuredId::Extensions::EmailAddress

  attr_accessor :id

  def self.find_by(id:)
    new if id.to_i == 7371
  end

  def self.find(id)
    return new if id.to_i == 7371

    raise MockRecordNotFound
  end

  def initialize(id: 7371)
    @id = id
  end
end

class MockRecordNotFound < StandardError; end

class ActiveRecordObscuredIdTest < Minitest::Test
  def setup
    @record = MockRecord.new

    ActiveRecord::ObscuredId.configure do |config|
      config.domain = 'test.com'
      config.old_domains = ['old-test.com']
    end
  end

  def test_that_it_has_a_version_number
    refute_nil ::ActiveRecord::ObscuredId::VERSION
  end

  def test_obscured_id
    assert_equal 'g4ztomi', @record.obscured_id
  end

  def test_find_obscured
    record = MockRecord.find_obscured('g4ztomi')

    assert record.is_a?(MockRecord)
    assert_equal 7371, record.id

    record = MockRecord.find_obscured('invalid')

    assert_nil record
  end

  def test_find_obscured!
    record = MockRecord.find_obscured!('g4ztomi')

    assert record.is_a?(MockRecord)
    assert_equal 7371, record.id

    assert_raises(MockRecordNotFound) do
      MockRecord.find_obscured!('invalid')
    end
  end

  def test_obscured_email_address
    assert_equal 'g4ztomi@mock-records.test.com', @record.obscured_email_address
  end

  def test_from_obscured_email_address
    record = MockRecord.from_obscured_email_address('g4ztomi@mock-records.test.com')

    assert record.is_a?(MockRecord)
    assert_equal 7371, record.id
  end

  def test_from_old_obscured_email_address
    record = MockRecord.from_obscured_email_address('g4ztomi@mock-records.old-test.com')

    assert record.is_a?(MockRecord)
    assert_equal 7371, record.id
  end

  def test_from_invalid_obscured_email_address
    record = MockRecord.from_obscured_email_address('invalid@mock-records.test.com')

    assert_nil record
  end
end
