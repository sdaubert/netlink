# frozen_string_literal: true

module Netlink
  # Netlink message error
  class NlmsgError < Nlmsg
    # @!attribute [Integer] error_code
    # @!attribute [Nlmsg::Header] orig_header
    attr_reader :error_code, :orig_header

    # @param [Integer] error_code
    # @param [Nlmsg::Header] orig_header
    def initialize(error_code=0, orig_header=Nlmsg::Header.new)
      @error_code = error_code
      @orig_header = orig_header
      super(error_code, orig_header)
    end

    # @see Nlmsg#encode_data
    # @return [String]
    def encode_data
      [@error_code].pack('L') << @orig_header.to_s
    end

    # @see Nlmsg#decode_data
    # @param [String] data
    # @return [void]
    def decode_data(data)
      @data = @error_code = data.unpack1('L')
      @orig_header = Nlmsg::Header.new.decode(data[4..])
    end

    # Say if the current message is an ACK one
    # @return [Boolean]
    def ack?
      @error_code.zero?
    end
  end
  Nlmsg.record_type(NLMSG_ERROR, NlmsgError)
end
