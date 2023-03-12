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

      # @private
      # Associate flag symbol to its integer value
      HDR_FLAGS = Constants.constants.map(&:to_s)
                           .select { |cst| cst.start_with?('NLM_F') }
                           .to_h { |cst| [cst.delete_prefix('NLM_F_').downcase.to_sym, Constants.const_get(cst.to_sym)] }
                           .freeze

      class << self
        # Decode a netlink message from +data+
        # @param [String] data
        # @return [Nlmsg] may be any of Nlmsg subclasses
        def decode(data)
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
        def register_type(type, klass)
          @types ||= {}
          @types[type] = klass
        end

        # @private
        # Helper to define TYPES constant from chosen constants from {Constant}
        # @param [String] prefix
        # @param [String] suffix
        # @return [void]
        def define_types_from_constants(prefix, suffix='')
          self.const_set(:TYPES,
                         Constants.constants
                                  .map(&:to_s)
                                  .select { |cst| cst.start_with?(prefix) && cst.end_with?(suffix) }
                                  .to_h { |cst| [cst.delete_prefix(prefix).downcase.to_sym, Constants.const_get(cst)] })
        end
      end

      define_types_from_constants('NLMSG_')

      private

      # @see Base#initialize_header
      def initialize_header(header)
        super
        @header.extend(MsgHeaderMixin)
        @header.types = self.class::TYPES
      end

      # @see Base#encode_header
      def encode_header(body)
        header.flags = encode_flags(header.flags)
        header.length = body.size + super.size
        super
      end

      # @see Base#decode_header
      def decode_header(data)
        header_size = super
        header.flags = decode_flags(header.flags)
        header_size
      end

      def encode_flags(flags)
        return 0 if flags.nil? || (flags.is_a?(Array) && flags.empty?)
        return flags if flags.is_a?(Integer)
        raise TypeError, 'unsupported type for flags' unless flags.is_a?(Array)

        flags.reduce(0) { |mem, flag| mem | flag_to_integer(flag) }
      end

      def flag_to_integer(flag)
        return flag if flag.is_a?(Integer)

        HDR_FLAGS[flag] || (raise Error, "Unknown flag #{flag}")
      end

      def decode_flags(int_or_flags)
        int = int_or_flags.is_a?(Array) ? encode_flags(int_or_flags) : int_or_flags.to_i
        flags = []
        pow2 = 1
        while pow2 <= int
          flags << HDR_FLAGS.key(pow2) || pow2 unless (int & pow2).zero?
          pow2 <<= 1
        end

        flags
      end
    end
  end
end
