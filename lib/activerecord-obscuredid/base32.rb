# frozen_string_literal: true

module ActiveRecord
  module ObscuredId
    # Implementation of Base32 encoding and decoding
    module Base32
      module_function

      BASE32_ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'

      def encode(input)
        # Convert input to a binary string
        binary = input.unpack1('B*')

        # Break the binary string into 5-bit chunks and map them to Base32 characters
        binary.scan(/.{1,5}/).map do |chunk|
          # Pad the chunk with zeroes to make it 5 bits long if needed
          chunk = chunk.ljust(5, '0')
          BASE32_ALPHABET[chunk.to_i(2)]
        end.join
      end

      def decode(base32_str)
        # Convert Base32 string to binary representation
        binary_str = base32_str.chars.map do |char|
          # Convert each character to its 5-bit binary equivalent
          index = BASE32_ALPHABET.index(char.upcase)
          raise ArgumentError, "Invalid Base32 character: #{char}" if index.nil?

          index.to_s(2).rjust(5, '0')
        end.join

        # Convert binary string back to its original form, ignoring extra zeroes
        decoded_str = [binary_str].pack('B*')

        # Strip out any null characters (trailing zero bits that resulted from padding)
        decoded_str.delete("\x00")
      end
    end
  end
end
