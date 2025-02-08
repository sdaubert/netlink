# frozen_string_literal: true

module Netlink
  module Nl
    class Link < PacketGen::Header::Base
      # define_types_from_constants('RTM_', 'LINK')

      define_attr :family, BinStruct::Int8
      define_attr :unused, BinStruct::Int8
      define_attr :type, BinStruct::Int16
      define_attr :index, BinStruct::Int32
      define_attr :flags, BinStruct::Int32
      define_attr :change, BinStruct::Int32

      KNOWN_ATTRIBUTES = {
        unspec: Attributes::Unspec,
        address: Attributes::MacAddr,
        broadcast: Attributes::MacAddr,
        ifname: Attributes::String,
        mtu: Attributes::U32,
        link: Attributes::Unspec,
        qdisc: Attributes::String,
        stats: Attributes::Unspec,
        cost: Attributes::Unspec,
        priority: Attributes::Unspec,
        master: Attributes::Unspec,
        wireless: Attributes::Unspec,
        protinfo: Attributes::Unspec,
        txqlen: Attributes::U32,
        map: Attributes::Unspec,
        weight: Attributes::Unspec,
        operstate: Attributes::U8,
        linkmode: Attributes::U8,
        fo: Attributes::Unspec,
        net_ns_pid: Attributes::Unspec,
        ifalias: Attributes::String,
        num_vf: Attributes::Unspec,
        vfinfo_list: Attributes::Unspec,
        stats64: Attributes::Unspec,
        vf_ports: Attributes::Unspec,
        port_self: Attributes::Unspec,
        af_spec: Attributes::Unspec,
        group: Attributes::U32,
        net_ns_fd: Attributes::Unspec,
        ext_mask: Attributes::Unspec,
        promiscuity: Attributes::U32,
        num_tx_queues: Attributes::U32,
        num_rx_queues: Attributes::U32,
        carrier: Attributes::Unspec,
        phys_port_id: Attributes::Unspec,
        carrier_changes: Attributes::Unspec,
        phys_switch_id: Attributes::Unspec,
        link_netnsid: Attributes::Unspec,
        phys_port_name: Attributes::Unspec,
        proto_down: Attributes::Unspec,
        gso_max_segs: Attributes::Unspec,
        gso_max_size: Attributes::Unspec,
        pad: Attributes::Unspec,
        xdp: Attributes::Unspec,
        event: Attributes::Unspec,
        new_netnsid: Attributes::Unspec,
        if_netnsid: Attributes::Unspec,
        carrier_up_count: Attributes::Unspec,
        carrier_down_count: Attributes::Unspec,
        new_ifindex: Attributes::Unspec,
        min_mtu: Attributes::U32,
        max_mtu: Attributes::U32,
        prop_list: Attributes::Unspec,
        alt_ifname: Attributes::Unspec,
        perm_address: Attributes::Unspec,
        proto_down_reason: Attributes::Unspec
      }.freeze
      define_attr :attributes, Attributes, builder: ->(_obj, type) { type.new(prefix: 'IFLA_', known: KNOWN_ATTRIBUTES) }

      # define_attributes prefix: 'IFLA_',
      #                   unspec: Attr::Unspec,
      #                   address: Attr::MacAddr,
      #                   broadcast: Attr::MacAddr,
      #                   ifname: Attr::String,
      #                   mtu: Attr::U32,
      #                   link: Attr::Unspec,
      #                   qdisc: Attr::String,
      #                   stats: Attr::Unspec,
      #                   cost: Attr::Unspec,
      #                   priority: Attr::Unspec,
      #                   master: Attr::Unspec,
      #                   wireless: Attr::Unspec,
      #                   protinfo: Attr::Unspec,
      #                   txqlen: Attr::U32,
      #                   map: Attr::Unspec,
      #                   weight: Attr::Unspec,
      #                   operstate: Attr::U8,
      #                   linkmode: Attr::U8,
      #                   fo: Attr::Unspec,
      #                   net_ns_pid: Attr::Unspec,
      #                   ifalias: Attr::String,
      #                   num_vf: Attr::Unspec,
      #                   vfinfo_list: Attr::Unspec,
      #                   stats64: Attr::Unspec,
      #                   vf_ports: Attr::Unspec,
      #                   port_self: Attr::Unspec,
      #                   af_spec: Attr::Unspec,
      #                   group: Attr::U32,
      #                   net_ns_fd: Attr::Unspec,
      #                   ext_mask: Attr::Unspec,
      #                   promiscuity: Attr::U32,
      #                   num_tx_queues: Attr::U32,
      #                   num_rx_queues: Attr::U32,
      #                   carrier: Attr::Unspec,
      #                   phys_port_id: Attr::Unspec,
      #                   carrier_changes: Attr::Unspec,
      #                   phys_switch_id: Attr::Unspec,
      #                   link_netnsid: Attr::Unspec,
      #                   phys_port_name: Attr::Unspec,
      #                   proto_down: Attr::Unspec,
      #                   gso_max_segs: Attr::Unspec,
      #                   gso_max_size: Attr::Unspec,
      #                   pad: Attr::Unspec,
      #                   xdp: Attr::Unspec,
      #                   event: Attr::Unspec,
      #                   new_netnsid: Attr::Unspec,
      #                   if_netnsid: Attr::Unspec,
      #                   carrier_up_count: Attr::Unspec,
      #                   carrier_down_count: Attr::Unspec,
      #                   new_ifindex: Attr::Unspec,
      #                   min_mtu: Attr::U32,
      #                   max_mtu: Attr::U32,
      #                   prop_list: Attr::Unspec,
      #                   alt_ifname: Attr::Unspec,
      #                   perm_address: Attr::Unspec,
      #                   proto_down_reason: Attr::Unspec

      # Link layer types
      LL_TYPES = {
        NETROM: 0,
        ETHER: 1,
        EETHER: 2,
        AX25: 3,
        PRONET: 4,
        CHAOS: 5,
        IEEE802: 6,
        ARCNET: 7,
        APPLETALK: 8,
        DLCI: 15,
        ATM: 19,
        METRICOM: 23,
        IEEE1394: 24,
        EUI64: 27,
        INFINIBAND: 32,
        SLIP: 256,
        CSLIP: 257,
        SLIP6: 258,
        CSLIP6: 259,
        CAN: 280,
        PPP: 512,
        RAWIP: 519,
        TUNNEL: 768,
        TUNNEL6: 769,
        LOOPBACK: 772,
        FDDI: 774,
        SIT: 776,
        IPGRE: 778,
        IRDA: 783,
        IEEE80211: 801,
        IEEE80211_PRISM: 803,
        IEEE80211_RADIOTAP: 804,
        IP6GRE: 823,
        NETLINK: 824,
        '6LOWPAN': 825
      }.freeze

      FIELDS_FLAGS = Constants.constants
                              .map(&:to_s)
                              .select { |cst| cst.start_with?('IFF_') }
                              .to_h { |cst| [cst.delete_prefix('IFF_').downcase.to_sym, Constants.const_get(cst.to_sym)] }
                              .freeze

      class Fields
        def human_type
          LL_TYPES.key(type) || type
        end

        def human_type=(sym)
          raise ArgumentError, 'unknown type' unless LL_TYPES.keys.include?(sym)

          self.type = LL_TYPES[sym]
        end

        def inspect
          fstr = case family
                 when ::Socket::AF_UNSPEC
                   'AF_UNSPEC'
                 when ::Socket::AF_BRIDGE
                   'PF_BRIDGE'
                 when ::Socket::AF_INET6
                   'PF_INET6'
                 else
                   family.to_s
                 end
          "#<#{self.class} family=#{fstr}, type=#{human_type}, index=#{index}, flags=#{flags}, change=#{change}>"
        end
      end

      class << self
        # Create a new GETLINK message
        # @return [LinkMsg]
        def getlink
          new(header: { type: Constants::RTM_GETLINK, flags: %i[request ack dump] })
        end

        # Create a new NEWLINK message (to create a new link, or update an existing one)
        # @return [LinkMsg]
        def newlink
          new(header: { type: Constants::RTM_NEWLINK, flags: %i[request ack] })
        end
      end

      def initialize(header: {}, fields: {}, attributes: {}, data: '')
        fields[:family] ||= ::Socket::AF_UNSPEC
        super
      end

      private

      def encode_fields
        fields.flags = encode_fields_flags(fields.flags)
        super
      end

      def decode_fields(data)
        size = super
        fields.flags = decode_fields_flags(fields.flags)

        size
      end

      def encode_fields_flags(flags)
        return 0 if flags.nil? || (flags.is_a?(Array) && flags.empty?)
        return flags if flags.is_a?(Integer)
        raise TypeError, 'unsupported type for flags' unless flags.is_a?(Array)

        flags.reduce(0) { |mem, flag| mem | (flag.is_a?(Integer) ? flag : FIELDS_FLAGS[flag] || (raise Error, "Unknwon flag #{flag}")) }
      end

      def decode_fields_flags(int_or_flags)
        int = int_or_flags.is_a?(Array) ? encode_fields_flags(int_or_flags) : int_or_flags.to_i
        flags = []
        pow2 = 1
        while pow2 <= int
          flags << FIELDS_FLAGS.key(pow2) || pow2 unless (int & pow2).zero?
          pow2 <<= 1
        end

        flags
      end
    end
    Msg.bind(Link, type: Constants::RTM_NEWLINK)
  end
end
