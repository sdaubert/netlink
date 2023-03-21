# frozen_string_literal: true
require 'awesome_print'

module Netlink
  module Route
    # Handle physical and virtual network devices through Netlink Route protocol.
    class Link
      attr_accessor :name, :group, :ifindex, :address, :broadcast_address, :mtu, :flags, :tx_queue_length, :operational_state, :mode, :ifalias, :hwtype, :qdisc, :promiscuity, :num_rx_queues, :num_tx_queues

      OPER_STATES = Constants.constants.select { |cst| cst.to_s.start_with?('IF_OPER') }
                             .to_h { |cst| [cst[8..].downcase.to_sym, Constants.const_get(cst)] }

      # Get information on all devices
      # @return [Array<Link>]
      def self.get
        socket = Socket.new(Constants::NETLINK_ROUTE)
        socket.bind(0)
        socket.sendmsg(Nl::LinkMsg.getlink)
        socket.recv_all.map { |msg| from_msg(msg) }
      ensure
        socket.close
      end

      # Create a new {Link} from a {Nl::LinkMsg}
      # @param [Nl::LinkMsg] msg
      # @return [Link]
      def self.from_msg(msg)
        lnk = new(msg.attributes[:ifname].value, msg.fields.flags)
        lnk.address = msg.attributes[:address].value
        lnk.broadcast_address = msg.attributes[:broadcast].value
        lnk.group = msg.attributes[:group].value
        lnk.ifindex = msg.fields.index
        lnk.mtu = msg.attributes[:mtu].value
        lnk.tx_queue_length = msg.attributes[:txqlen].value
        lnk.operational_state = msg.attributes[:operstate].value
        lnk.mode = msg.attributes[:linkmode].value
        lnk.ifalias = msg.attributes[:ifalias]&.value
        lnk.qdisc = msg.attributes[:qdisc].value
        lnk.promiscuity = msg.attributes[:promiscuity].value
        lnk.num_rx_queues = msg.attributes[:num_rx_queues].value
        lnk.num_tx_queues = msg.attributes[:num_tx_queues].value
        lnk.hwtype = msg.fields.human_type

         lnk
      end

      # @param [String] name
      # @param [String] address
      # @param [String] broadcast
      # @param [Array<Symbol>] flags
      def initialize(name, flags=[])
        @type = nil
        @name = name
        @address = ''
        @broadcast_address = ''
        @flags = flags
        @group = -1
        @ifindex = 0
        @mtu = 1500
        @tx_queue_length = -1
        @operational_state = :down
        @mode = 0
        @ifalias = nil
        @hwtype = :ETHER
        @qdisc = 'noqueue'
        @promiscuity = 0
        @num_rx_queues = -1
        @num_tx_queues = -1
      end

      # Update a link
      def update
        socket = Socket.new(Constants::NETLINK_ROUTE)
        socket.bind(0)
        msg = Nl::LinkMsg.newlink
        update_msg(msg)
        socket.sendmsg(msg)
        socket.recvmsg
      ensure
        socket.close
      end

      # Create a link. Only virtual network devices may be created.
      def create(type)
        socket = Socket.new(Constants::NETLINK_ROUTE)
        socket.bind(0)
        msg = Nl::LinkMsg.newlink
        @type = type
        update_msg(msg)
        msg.header.flags << :create << :excl
        ap msg
        socket.sendmsg(msg)
        socket.recvmsg
      ensure
        socket.close
      end


      def update_msg(msg)
        msg.add_attribute(:ifname, @name)
        msg.add_attribute(:address, @address) unless @address.empty?
        msg.add_attribute(:broadcast, @broadcast_address) unless @broadcast_address.empty?
        #msg.add_attribute(:mtu, @mtu)
        #msg.add_attribute(:operstate, operstate_to_int(@operational_state))
        #msg.add_attribute(:linkmode, @mode)
        #msg.add_attribute(:qdisc, @qdisc)
        #msg.add_attribute(:promiscuity, @promiscuity)

        msg.add_attribute(:group, @group) unless @group == -1
        msg.add_attribute(:txqlen, @tx_queue_length) unless @tx_queue_length == -1
        msg.add_attribute(:ifalias, @ifalias) unless @ifalias.nil?
        msg.add_attribute(:num_rx_queues, @num_rx_queues) unless @num_rx_queues == -1
        msg.add_attribute(:num_tx_queues, @num_tx_queues) unless @num_tx_queues == -1

        add_linkinfo(msg, @type)

        msg.fields.index = @ifindex
        msg.fields.flags = @flags
        msg.fields.human_type = @hwtype
      end

      def operstate_to_sym(val)
        return val if val.is_a?(Symbol)

        OPER_STATES.key(val) || val
      end

      def operstate_to_int(val)
        return val if val.is_a?(Integer)

        OPER_STATES[val] || (raise IndexError, "Unknown operstate #{val}")
      end

      def add_linkinfo(msg, kind)
        return if kind.nil? || kind.empty?

        @hwtype = :NETROM
        li = Nl::Attr::LinkInfo.new
        li.add_attribute(:kind, kind)
        p li
        msg.attributes[:linkinfo] = li
      end
    end
  end
end
