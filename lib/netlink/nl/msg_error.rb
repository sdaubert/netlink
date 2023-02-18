# frozen_string_literal: true

module Netlink
  module Nl
    # Netlink message error
    class MsgError < Msg
      define_fields error: 'i'

      # @param [Integer] error
      # @param [Nlmsg::Header] orig_header
      def initialize(error: 0, orig_header: {})
        super(header: orig_header, fields: { error: error })
      end

      # Say if the current message is an ACK one
      # @return [Boolean]
      def ack?
        fields.error.zero?
      end
    end
    Msg.record_type(NLMSG_ERROR, MsgError)
  end
end
