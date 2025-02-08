# frozen_string_literal: true

module Netlink
  module Nl
    # Platform dependent width signed interger, native endian
    class CInt < BinStruct::Int
      def initialize(value=nil)
        super(value:, width: [0].pack('i').size)
        @packstr = { nil => 'i' }
      end
    end

    # Native-endian 16-bit integer
    class Int16n < BinStruct::Int16n; end

    # Native-endian 32-bit integer
    class Int32n < BinStruct::Int32n; end

    # Native-endian 64-bit integer
    class Int64n < BinStruct::Int64n; end
  end
end
