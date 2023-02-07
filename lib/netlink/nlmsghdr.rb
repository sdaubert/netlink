# frozen_string_literal: true

module Netlink
  class NlMsgHdr
    attr_accessor :length
    attr_reader :type, :flags, :seq, :pid

    # Size of a nlmsgheader
    SIZE = 16
    # nlmsghdr pack string
    PACK_STR = 'LSSLL'

    # Create a +nlmsghdr+ from a pack string
    # @param [String] str
    # @return [NlMsgHdr]
    def self.from_string(str)
      ary = str.unpack(PACK_STR)
      new(*ary)
    end

    # @param [Integer] length message length
    # @param [Integer] type message type
    # @param [Integer] flags message flags
    # @param [Integer] seq message sequence number
    # @param [Integer] pid message port id
    def initialize(length, type, flags, seq, pid)
      @length = length
      @type = type
      @flags = flags
      @seq = seq
      @pid = pid
    end

    # @return [String]
    def to_s
      [@length, @type, @flags, @seq, @pid].pack(PACK_STR)
    end

    # Compute +length+ field from +mesg+
    # @param [String] mesg
    # @return [Integer]
    def compute_length(mesg)
      @length = SIZE + mesg.size
    end
  end

  class NlMsgError
    attr_reader :error_code, :orig_header

    def self.from_string(msg)
      error_code = msg[0, 4].unpack1('L')
      orig_header = NlMsgHdr.from_string(msg[4, NlMsgHdr::SIZE])
      new(error_code, orig_header)
    end

    def initialize(error_code, orig_header)
      @error_code = error_code
      @orig_header = orig_header
    end

    def to_s
      [@error_code].pack('L') << @orig_header.to_s
    end

    def ack?
      @error_code.zero?
    end
  end
end
