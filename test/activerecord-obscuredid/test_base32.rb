# frozen_string_literal: true

require_relative '../test_helper'

class Base32Test < Minitest::Test
  def test_encode
    assert_equal 'GEZDG', ActiveRecord::ObscuredId::Base32.encode('123')
    assert_equal 'NBSWY3DPEB3W64TMMQ', ActiveRecord::ObscuredId::Base32.encode('hello world')
  end

  def test_decode
    assert_equal '123', ActiveRecord::ObscuredId::Base32.decode('GEZDG')
    assert_equal 'hello world', ActiveRecord::ObscuredId::Base32.decode('NBSWY3DPEB3W64TMMQ')
  end

  def test_invalid_character
    assert_raises(ArgumentError) do
      ActiveRecord::ObscuredId::Base32.decode('INVALID!')
    end
  end
end
