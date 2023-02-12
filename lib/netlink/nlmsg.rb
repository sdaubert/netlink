# frozen_string_literal: true

module Netlink
  # Mixin to make some classes pad-enabled
  module NlmsgPad
    # Add padding to given +data+
    # @param [String] data
    # @return [String]
    def pad(data)
      data.b << "\x00" * -(data.size % -@align)
    end
  end

  # Netlink message class
  #
  # A netlink message is composed of a {Header header} and associated data:
  #   +----------+- - -+- - - - - - - - +- - -+
  #   |  header  | Pad |     Payload    | Pad |
  #   +----------+- - -+- - - - - - - - +- - -+
  class Nlmsg
    # Netlink message header class
    #
    # This header encodes:
    # * total length of netlink message (including header length),
    # * message type,
    # * message flags,
    # * sequence number,
    # * sender port ID.
    class Header
      include NlmsgPad

      # @!attribute [Integer] type
      # @!attribute [Integer] flags
      # @!attribute [Integer] seq
      # @!attribute [Integer] pid
      attr_accessor :type, :flags, :seq, :pid
      # @!attribute [Integer] length
      attr_reader :length

      # Nlmsg header pack string
      HDR_PACK_STR = 'LSSLL'

      # @param [Integer] type
      # @param [Integer] flags
      # @param [Integer] seq
      # @param [Integer] pid
      def initialize(type: 0, flags: 0, seq: 0, pid: 0)
        @length = 0
        @type = type
        @flags = flags
        @seq = seq
        @pid = pid
        @align = 4
      end

      # Encode header to a binary String
      # @return [String]
      def encode
        hdr = [@length, @type, @flags, @seq, @pid].pack(HDR_PACK_STR)
        pad(hdr)
      end

      # Decode header from a binary String
      # @param [String] data
      # @return [Array(Integer, Integer)] array with 2 elements: first is header length, second
      #   is data length, without padding
      def decode(data)
        @length, @type, @flags, @seq, @pid = data.unpack(HDR_PACK_STR)
        [size, @length - size]
      end

      # Get header size
      # @return [Integer]
      def size
        16
      end

      # Compute {#length} attribute from +encoded_data+
      # @param [String] encoded_data
      def compute_length(encoded_data)
        @length = size + encoded_data.size
      end
    end

    include NlmsgPad

    # @!attribute [String] data
    # @!attribute [Header] header
    attr_accessor :data, :header

    # Decode a netlink message from +data+
    # @param [String] data
    # @return [Nlmsg] may be any of Nlmsg subclasses
    def self.decode(data)
      nlmsg = self.new
      nlmsg.decode!(data)
      return nlmsg unless self == Nlmsg

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
    def initialize(data='', header=Header.new)
      @header = header
      @data = data
      @align = 4
    end

    # Encode all netlink message (including {Header})
    # @return [String] encoded netlink message as binary String
    def encode
      encoded_data = pad(encode_data)
      @header.compute_length(encoded_data)
      @header.encode << encoded_data
    end

    # Encode data
    # @return [String] encoded data as binary String
    def encode_data
      @data.to_s.b
    end

    # Decode a netlink message from a binary String
    # @param [String] data
    # @return [Nlmsg]
    def decode!(data)
      data_idx, data_length = header.decode(data)
      decode_data(data[data_idx, data_length])
    end

    # Decode given +data+
    # @param [String] data
    # @return [void]
    def decode_data(data)
      @data = data
    end
  end

  class NlmsgError < Nlmsg
    attr_reader :error_code, :orig_header

    def initialize(error_code=0, orig_header=Nlmsg::Header.new)
      @error_code = error_code
      @orig_header = orig_header
      super(error_code, orig_header)
    end

    def encode_data
      [@error_code].pack('L') << @orig_header.to_s
    end

    def decode_data(data)
      @data = @error_code = data.unpack1('L')
      @orig_header = Nlmsg::Header.new.decode(data[4..])
    end

    def ack?
      @error_code.zero?
    end
  end
  Nlmsg.record_type(NLMSG_ERROR, NlmsgError)
end
