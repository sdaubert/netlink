# frozen_string_literal: true

require 'socket'
require 'forwardable'

module Netlink
  # Handle a netlink socket
  class Socket
    extend Forwardable

    # Netlink domain socket
    AF_NETLINK = 16

    def_delegators :@socket, :bind, :close, :getsockopt, :setsockopt, :recvmsg, :sendmsg, :shutdown

    class << self
      # @return [Integer]
      def generate_pid
        @next_pid = Process.pid unless defined? @next_pid

        pid = @next_pid
        @next_pid += 1
        pid
      end

      alias old_new new

      def new(family)
        sock = old_new(family)
        if block_given?
          yield sock
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
    end

    # @return [Array[Strinh, Integer]] => ['AF_NETLINK', pid, groups]
    def addr
      ['AF_NETLINK', @pid, 0]
    end

    # @return [String]
    def inspect
      "#<#{self.class}:fd #{@socket.fileno}, AF_NETLINK, #{@family}, #{@pid}>"
    end
  end
end
