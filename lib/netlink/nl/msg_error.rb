# frozen_string_literal: true

module Netlink
  module Nl
    # Netlink message error
    class MsgError < MsgBase
      define_attr :error, CInt
      define_attr :body, BinStruct::String

      alias orig_header body

      # Say if the current message is an ACK one
      # @return [Boolean]
      def ack?
        error.zero?
      end

      def string_error
        return 'ACK' if ack?

        errno = SystemCallError.new('', error.abs)
        "#{errno.class.to_s.delete_prefix('Errno::')},#{errno.message.delete_suffix(' - ')}"
      end
    end
    PacketGen::Header.add_class(MsgError)
    Msg.bind(MsgError, type: Constants::NLMSG_ERROR)
    MsgError.bind(Msg)
  end
end
