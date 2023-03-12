# frozen_string_literal: true

module Netlink
  module Nl
    # Netlink message error
    class MsgError < Msg
      define_fields error: 'i'

      # @param [Integer] error
      # @param [Hash] orig_header
      def initialize(error: 0, orig_header: {})
        super(header: orig_header, fields: { error: error })
      end

      # Say if the current message is an ACK one
      # @return [Boolean]
      def ack?
        fields.error.zero?
      end

      def string_error
        return 'ACK' if fields.error.zero?

        errno = SystemCallError.new('', fields.error.abs)
        "#{errno.class.to_s.delete_prefix('Errno::')},#{errno.message.delete_suffix(' - ')}"
      end

      def inspect
        "#<#{self.class} error=(#{fields.error},#{string_error}), @header=#{header.inspect}, @attributes=#{attributes.inspect}, @data=#{data.inspect}>"
      end
    end
    Msg.register_type(Constants::NLMSG_ERROR, MsgError)
  end
end
