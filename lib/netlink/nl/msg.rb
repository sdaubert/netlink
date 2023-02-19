# frozen_string_literal: true

module Netlink
  module Nl
    # Netlink message class
    #
    # A netlink message is composed of a header, supplementary fields (i.e. additional header) and attributes.
    #
    # This base netlink message class only implements support for header and data (all others fields as a binary blob).
    # Subclasses should implement support for fields and attributes.
    # A netlink message must have its header and its payload align on {.align} bytes:
    #   +----------+- - -+- - - - - - - - +- - -+
    #   |  header  | Pad |     Payload    | Pad |
    #   +----------+- - -+- - - - - - - - +- - -+
    #
    # Netlink message header is composed of:
    #   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #   |                            Length                             |
    #   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #   |              Type             |             Flags             |
    #   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #   |                              Seq                              |
    #   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #   |                              PID                              |
    #   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    # with:
    # * length, 32-bit unsigned integer, length of all netlink message, including header, but not final padding,
    # * type, 16-bit unsigned integer, type of message (one of +NLMSG_*+ constants),
    # * flags, 16-bit unsigned integer, bitwise-OR of some +NLM_F_*+ constants,
    # * seq, 32-bit unsigned integer, sequence number of message,
    # * pid, 32-bit unsigned integer, sender port ID.
    class Msg < Base
      define_header length: 'L',
                    type: 'S',
                    flags: 'S',
                    seq: 'L',
                    pid: 'L'

      # Decode a netlink message from +data+
      # @param [String] data
      # @return [Nlmsg] may be any of Nlmsg subclasses
      def self.decode(data)
        nlmsg = self.new
        nlmsg.decode(data)
        return nlmsg unless self == Msg

        specific_klass = @types[nlmsg.header.type]
        return nlmsg if specific_klass.nil?

        specific_klass.decode(data)
      end

      # Record a class as a specific netlink message type
      # @param [Integer] type
      # @param [Class] klass
      # @return [void]
      def self.record_type(type, klass)
        @types ||= {}
        @types[type] = klass
      end

      # @param [String] data
      # @param [Header] header
      def initialize(header: {}, fields: {}, attributes: {}, data: '')
        super(header: header, fields: fields, attributes: attributes)
        @data = data
      end

      def encode(data=nil)
        str = encode_content(data)
        header.length = str.size + encode_header.size
        encode_header << str
      end
    end
  end
end
