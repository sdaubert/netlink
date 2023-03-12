# frozen_string_literal: true

module Netlink
  module Route
    # Handle physical and virtual network devices through Netlink Route protocol.
    class Link
      attr_accessor :name, :group, :ifindex, :address, :broadcast_address, :mtu, :flags, :tx_queue_length, :operational_state, :mode, :ifalias, :hwtype, :qdisc, :promiscuity, :num_rx_queues, :num_tx_queues

      # Get information on all devices
      # @return [Array<Link>]
      def self.get
        socket = Socket.new(Constants::NETLINK_ROUTE)
        socket.bind(0)
        socket.sendmsg(Nl::LinkMsg.getlink)
        socket.recv_all.map { |msg| from_msg(msg) }
      end

      # Create a new {Link} from a {Nl::LinkMsg}
      # @param [Nl::LinkMsg] msg
      # @return [Link]
      def self.from_msg(msg)
        new(msg.attributes[:ifname].value,
            msg.attributes[:group].value,
            msg.fields.index,
            msg.attributes[:address].value,
            msg.attributes[:broadcast].value,
            msg.attributes[:mtu].value,
            msg.fields.flags,
            msg.attributes[:txqlen].value,
            msg.attributes[:operstate].value,
            msg.attributes[:linkmode].value,
            msg.attributes[:ifalias]&.value,
            msg.fields.human_type,
            msg.attributes[:qdisc].value,
            msg.attributes[:promiscuity].value,
            msg.attributes[:num_rx_queues].value,
            msg.attributes[:num_rx_queues].value)
      end

      # @param [String] name
      # @param [Integer] group
      # @param [Integer] ifindex
      # @param [String] address
      # @param [String] broadcast
      # @param [Integer] mtu
      # @param [Array<Symbol>] flags
      # @param [Integer] txqlen
      # @param [Integer] operstate
      # @param [Integer] mode
      # @param [String,nil] ifalias
      # @param [Symbol] hwtype
      # @param [String] qdisc
      # @param [Integer] promiscuity
      # @param [Integer] num_rx_queues
      # @param [Integer] num_tx_queues
      def initialize(name, group, ifindex, address, broadcast, mtu, flags, txqlen, operstate, mode, ifalias, hwtype, qdisc, promiscuity, num_rx_queues, num_tx_queues)
        @name = name
        @group = group
        @ifindex = ifindex
        @address = address
        @broadcast_address = broadcast
        @mtu = mtu
        @flags = flags
        @tx_queue_length = txqlen
        @operational_state = operstate
        @mode = mode
        @ifalias = ifalias
        @hwtype = hwtype
        @qdisc = qdisc
        @promiscuity = promiscuity
        @num_rx_queues = num_rx_queues
        @num_tx_queues = num_tx_queues
      end
    end
  end
end
