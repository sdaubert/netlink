# frozen_string_literal: true

module Netlink
  module Nl
    class LinkMsg < Msg
      define_types_from_constants('RTM_', 'LINK')

      define_fields family: 'C',
                    unused: 'C',
                    type: 'S',
                    index: 'L',
                    flags: 'L',
                    change: 'L'

      define_attributes prefix: 'IFLA_',
                        unspec: Attr::Unspec,
                        address: Attr::MacAddr,
                        broadcast: Attr::MacAddr,
                        ifname: Attr::String,
                        mtu: Attr::U32,
                        link: Attr::Unspec,
                        qdisc: Attr::String,
                        stats: Attr::Unspec,
                        cost: Attr::Unspec,
                        priority: Attr::Unspec,
                        master: Attr::Unspec,
                        wireless: Attr::Unspec,
                        protinfo: Attr::Unspec,
                        txqlen: Attr::U32,
                        map: Attr::Unspec,
                        weight: Attr::Unspec,
                        operstate: Attr::U8,
                        linkmode: Attr::U8,
                        linkinfo: Attr::Unspec,
                        net_ns_pid: Attr::Unspec,
                        ifalias: Attr::String,
                        num_vf: Attr::Unspec,
                        vfinfo_list: Attr::Unspec,
                        stats64: Attr::Unspec,
                        vf_ports: Attr::Unspec,
                        port_self: Attr::Unspec,
                        af_spec: Attr::Unspec,
                        group: Attr::U32,
                        net_ns_fd: Attr::Unspec,
                        ext_mask: Attr::Unspec,
                        promiscuity: Attr::U32,
                        num_tx_queues: Attr::U32,
                        num_rx_queues: Attr::U32,
                        carrier: Attr::Unspec,
                        phys_port_id: Attr::Unspec,
                        carrier_changes: Attr::Unspec,
                        phys_switch_id: Attr::Unspec,
                        link_netnsid: Attr::Unspec,
                        phys_port_name: Attr::Unspec,
                        proto_down: Attr::Unspec,
                        gso_max_segs: Attr::Unspec,
                        gso_max_size: Attr::Unspec,
                        pad: Attr::Unspec,
                        xdp: Attr::Unspec,
                        event: Attr::Unspec,
                        new_netnsid: Attr::Unspec,
                        if_netnsid: Attr::Unspec,
                        carrier_up_count: Attr::Unspec,
                        carrier_down_count: Attr::Unspec,
                        new_ifindex: Attr::Unspec,
                        min_mtu: Attr::U32,
                        max_mtu: Attr::U32,
                        prop_list: Attr::Unspec,
                        alt_ifname: Attr::Unspec,
                        perm_address: Attr::Unspec,
                        proto_down_reason: Attr::Unspec

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
          LL_TYPES.key(type).to_s || type
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
        def getlink
          new(header: { type: Constants::RTM_GETLINK, flags: %i[request ack dump] })
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
    Msg.register_type(Constants::RTM_NEWLINK, LinkMsg)
  end
end
