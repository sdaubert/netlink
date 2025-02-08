# frozen_string_literal: true

module Netlink
  module Nl
    class MsgBase < PacketGen::Header::Base
      class << self
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

        # Give protocol name for this class
        # @return [String]
        def protocol_name
          return @protocol_name if defined? @protocol_name

          @protocol_name = to_s.sub('Netlink::', '')
        end
      end
    end

    # Netlink message class
    #
    # A netlink message is composed of a header, supplementary fields (i.e. additional header) and attributes.
    #
    # This base netlink message class only implements support for header and data (all others fields as a binary blob).
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
    class Msg < MsgBase
      define_attr :length, Int32n
      define_attr :type, Int16n
      define_attr :flags, Int16n
      define_attr :seq, Int32n
      define_attr :pid, Int32n
      define_attr :body, BinStruct::String

      # @private
      # Associate flag symbol to its integer value
      HDR_FLAGS = Constants.constants.map(&:to_s)
                           .select { |cst| cst.start_with?('NLM_F') }
                           .to_h { |cst| [cst.delete_prefix('NLM_F_').downcase.to_sym, Constants.const_get(cst.to_sym)] }
                           .freeze

      define_types_from_constants('NLMSG_')

      def initialize(options={})
        if options[:flags].is_a?(Array)
          raise TypeError, 'flags should be an array of symbols' if options[:flags].any? { |f| !f.is_a?(Symbol) }

          options[:flags] = encode_flags(options[:flags])
        end
        super
      end

      def to_s
        self.length = super.size
        super
      end

      private

      def encode_flags(flags)
        flags.reduce(0) { |mem, flag| mem | flag_to_integer(flag) }
      end

      def flag_to_integer(flag)
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
    PacketGen::Header.add_class(Msg)
  end
end
