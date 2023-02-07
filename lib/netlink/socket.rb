# frozen_string_literal: true

require 'socket'
require 'forwardable'

module Netlink
  # Handle a netlink socket
  class Socket
    extend Forwardable

    # Netlink domain socket
    AF_NETLINK = 16
    # Default buffer size
    DEFAULT_BUFFER_SIZE = 32 * 1024

    def_delegators :@socket, :bind, :close, :fileno, :getsockopt, :setsockopt

    class << self
      # Generate a Port Id from Process Id (on 22 bits) and a counter (on 10 bits)
      # @return [Integer]
      def generate_pid
        @next_pid = Process.pid << 10 unless defined? @next_pid

        pid = @next_pid
        @next_pid += 1
        pid
      end

      alias old_new new

      def new(family)
        sock = old_new(family)
        if block_given?
          begin
            yield sock
          ensure
            sock.close
          end
        else
          sock
        end
      end
      alias open new

      # Pack +pid+ and +groups+ as a {AF_NETLINK} sockaddr string.
      # @param [Integer] pid
      # @param [Integer] groups
      def sockaddr_nl(pid, groups)
        [AF_NETLINK, 0, pid, groups].pack('SSLL')
      end
    end

    # @param [Integer] family Netlink family
    def initialize(family)
      @family = family
      @pid = self.class.generate_pid
      @socket = ::Socket.new(AF_NETLINK, ::Socket::SOCK_RAW, family)
      @seqnum = 1
      @default_buffer_size = DEFAULT_BUFFER_SIZE
      @groups = 0
    end

    # @return [Array(String, Integer, Integer)] First element is the socket family name, second is the socket's pid and the third, the groups
    def addr
      ['AF_NETLINK', @pid, @groups]
    end

    # @return [String]
    def inspect
      "#<#{self.class}:fd #{@socket.fileno}, AF_NETLINK, #{@family}, #{@pid}>"
    end

    # Binds a socket to its pid and to given groups
    # @param [Integer] groups
    # @return [0]
    # @raise [Errno]
    def bind(groups)
      @groups = groups
      sockaddr = self.class.sockaddr_nl(@pid, groups)
      @socket.bind(sockaddr)
    end

    # Send +mesg+ via socket
    # @param [String] mesg message to send
    # @param [Integer] nlm_type Message Type
    # @param [Integer] nlm_flags Netlink message flags. Should be a bitwise OR of {Netlink}::NLM_F_* constants
    # @param [Integer] flags +flags+ Socket flags. Should be a bitwise OR of {::Socket}::MSG_* constants
    # @param [String,Addrinfo,nil] dest_sockaddr
    # @return [Integer] number of bytes sent
    def sendmsg(mesg, nlm_type, nlm_flags=0, flags=0, dest_sockaddr=nil)
      nlmsg = create_nlmsg(mesg, nlm_type, nlm_flags)
      @socket.sendmsg(nlmsg, flags, dest_sockaddr.to_s)
    end

    # Receive a message
    # @param [Integer] maxmesglen maximum number of bytes to receive as message
    # @param [Integer] flags +flags+ should be a bitwise OR of {::Socket}::MSG_* constants
    # @return [Array(String, Addrinfo, Integer, NlMsgHdr)] +[mesg, sender_addrinfo, rflags, controls]+ where:
    #   * +mesg+ is the message as a String or a {NlMsgError},
    #   * +sender_addrinfo+ is a {Addrinfo} about sender,
    #   + +controls+ is the ancillary data, here the header of message as a {NlMsgHdr}.
    # @raise [NlmsgError]
    def recvmsg(maxmesglen=nil, flags=0)
      maxmesglen ||= @default_buffer_size
      maxlen = maxmesglen + NlMsgHdr::SIZE
      mesg, sender_ai, = @socket.recvmsg(maxlen, flags)
      hdr = NlMsgHdr.from_string(mesg.slice!(0, NlMsgHdr::SIZE))
      if hdr.type == NLMSG_ERROR
        mesg = NlMsgError.from_string(mesg)
        raise Error, "Error #{mesg.error_code} for message with seq #{mesg.orig_header.seq} from pid #{mesg.orig_header.pid}" unless mesg.ack?
      end

      mesg = mesg[0, maxmesglen] if mesg.is_a?(String)
      [mesg, Addrinfo.new(sender_ai.to_sockaddr), hdr]
    end

    private

    # Create a NlMsg from +mesg+ by adding header and padding
    # @param [String] mesg
    # @param [Integer] type message type
    # @param [Integer] flags +flags+ should be a bitwise OR of {Netlink}::NETLINK_F_* constants
    # @return [String]
    def create_nlmsg(mesg, type, flags)
      hdr = NlMsgHdr.new(0, type, flags, seqnum, @pid)
      hdr.compute_length(mesg)
      hdr.to_s << mesg
    end

    # Return sequence number to use
    # @return [Integer]
    def seqnum
      current_seqnum = @seqnum
      @seqnum += 1
      current_seqnum
    end
  end
end
