# frozen_string_literal: true

module Netlink
  module Constants
    # Routing/device hook
    NETLINK_ROUTE = 0
    # Unused number
    NETLINK_UNUSED = 1
    # Reserved for user mode socket protocols
    NETLINK_USERSOCK = 2
    # Unused number, formerly ip_queue
    NETLINK_FIREWALL = 3
    # socket monitoring
    NETLINK_SOCK_DIAG = 4
    # netfilter/iptables ULOG
    NETLINK_NFLOG = 5
    # ipsec
    NETLINK_XFRM = 6
    # SELinux event notifications
    NETLINK_SELINUX = 7
    # Open-iSCSI
    NETLINK_ISCSI = 8
    # auditing
    NETLINK_AUDIT = 9
    NETLINK_FIB_LOOKUP = 10
    NETLINK_CONNECTOR = 11
    # netfilter subsystem
    NETLINK_NETFILTER = 12
    NETLINK_IP6_FW = 13
    # DECnet routing messages
    NETLINK_DNRTMSG = 14
    # Kernel messages to userspace
    NETLINK_KOBJECT_UEVENT = 15
    NETLINK_GENERIC = 16
    # SCSI Transports
    NETLINK_SCSITRANSPORT = 18
    NETLINK_ECRYPTFS = 19
    NETLINK_RDMA = 20
    # Crypto layer
    NETLINK_CRYPTO = 21
    # SMC monitoring
    NETLINK_SMC = 22
    NETLINK_INET_DIAG = NETLINK_SOCK_DIAG
    NETLINK_ADD_MEMBERSHIP = 1
    NETLINK_DROP_MEMBERSHIP = 2
    NETLINK_PKTINFO = 3
    NETLINK_BROADCAST_ERROR = 4
    NETLINK_NO_ENOBUFS = 5
    NETLINK_RX_RING = 6
    NETLINK_TX_RING = 7
    NETLINK_LISTEN_ALL_NSID = 8
    NETLINK_LIST_MEMBERSHIPS = 9
    NETLINK_CAP_ACK = 10
    NETLINK_EXT_ACK = 11
    NETLINK_GET_STRICT_CHK = 12
    # It is request message.
    NLM_F_REQUEST = 0x01
    # Multipart message, terminated by NLMSG_DONE
    NLM_F_MULTI = 0x02
    # Reply with ack, with zero or error code
    NLM_F_ACK = 0x04
    # Echo this request
    NLM_F_ECHO = 0x08
    # Dump was inconsistent due to sequence change
    NLM_F_DUMP_INTR = 0x10
    # Dump was filtered as requested
    NLM_F_DUMP_FILTERED = 0x20
    # specify tree root
    NLM_F_ROOT = 0x100
    # return all matching
    NLM_F_MATCH = 0x200
    # atomic GET
    NLM_F_ATOMIC = 0x400
    NLM_F_DUMP = (NLM_F_ROOT|NLM_F_MATCH)
    # Override existing
    NLM_F_REPLACE = 0x100
    # Do not touch, if it exists
    NLM_F_EXCL = 0x200
    # Create, if it does not exist
    NLM_F_CREATE = 0x400
    # Add to end of list
    NLM_F_APPEND = 0x800
    # Do not delete recursively
    NLM_F_NONREC = 0x100
    # request was capped
    NLM_F_CAPPED = 0x100
    # extended ACK TVLs were included
    NLM_F_ACK_TLVS = 0x200
    # Nothing.
    NLMSG_NOOP = 0x1
    # Error
    NLMSG_ERROR = 0x2
    # End of a dump
    NLMSG_DONE = 0x3
    # Data lost
    NLMSG_OVERRUN = 0x4
    RTM_NEWLINK = 16
    RTM_DELLINK = 17
    RTM_GETLINK = 18
    RTM_SETLINK = 19
    RTM_NEWADDR = 20
    RTM_DELADDR = 21
    RTM_GETADDR = 22
    RTM_NEWROUTE = 24
    RTM_DELROUTE = 25
    RTM_GETROUTE = 26
    RTM_NEWNEIGH = 28
    RTM_DELNEIGH = 29
    RTM_GETNEIGH = 30
    RTM_NEWRULE = 32
    RTM_DELRULE = 33
    RTM_GETRULE = 34
    RTM_NEWQDISC = 36
    RTM_DELQDISC = 37
    RTM_GETQDISC = 38
    RTM_NEWTCLASS = 40
    RTM_DELTCLASS = 41
    RTM_GETTCLASS = 42
    RTM_NEWTFILTER = 44
    RTM_DELTFILTER = 45
    RTM_GETTFILTER = 46
    RTM_NEWACTION = 48
    RTM_DELACTION = 49
    RTM_GETACTION = 50
    RTM_NEWPREFIX = 52
    RTM_GETMULTICAST = 58
    RTM_GETANYCAST = 62
    RTM_NEWNEIGHTBL = 64
    RTM_GETNEIGHTBL = 66
    RTM_SETNEIGHTBL = 67
    RTM_NEWNDUSEROPT = 68
    RTM_NEWADDRLABEL = 72
    RTM_DELADDRLABEL = 73
    RTM_GETADDRLABEL = 74
    RTM_GETDCB = 78
    RTM_SETDCB = 79
    RTM_NEWNETCONF = 80
    RTM_DELNETCONF = 81
    RTM_GETNETCONF = 82
    RTM_NEWMDB = 84
    RTM_DELMDB = 85
    RTM_GETMDB = 86
    RTM_NEWNSID = 88
    RTM_DELNSID = 89
    RTM_GETNSID = 90
    RTM_NEWSTATS = 92
    RTM_GETSTATS = 94
    RTM_NEWCACHEREPORT = 96
    RTM_NEWCHAIN = 100
    RTM_DELCHAIN = 101
    RTM_GETCHAIN = 102
    RTM_NEWNEXTHOP = 104
    RTM_DELNEXTHOP = 105
    RTM_GETNEXTHOP = 106
    RTM_NEWLINKPROP = 108
    RTM_DELLINKPROP = 109
    RTM_GETLINKPROP = 110
    RTM_NEWVLAN = 112
    RTM_DELVLAN = 113
    RTM_GETVLAN = 114
    IFLA_UNSPEC = 0
    IFLA_ADDRESS = 1
    IFLA_BROADCAST = 2
    IFLA_IFNAME = 3
    IFLA_MTU = 4
    IFLA_LINK = 5
    IFLA_QDISC = 6
    IFLA_STATS = 7
    IFLA_COST = 8
    IFLA_PRIORITY = 9
    IFLA_MASTER = 10
    IFLA_WIRELESS = 11
    IFLA_PROTINFO = 12
    IFLA_TXQLEN = 13
    IFLA_MAP = 14
    IFLA_WEIGHT = 15
    IFLA_OPERSTATE = 16
    IFLA_LINKMODE = 17
    IFLA_LINKINFO = 18
    IFLA_NET_NS_PID = 19
    IFLA_IFALIAS = 20
    IFLA_NUM_VF = 21
    IFLA_VFINFO_LIST = 22
    IFLA_STATS64 = 23
    IFLA_VF_PORTS = 24
    IFLA_PORT_SELF = 25
    IFLA_AF_SPEC = 26
    IFLA_GROUP = 27
    IFLA_NET_NS_FD = 28
    IFLA_EXT_MASK = 29
    IFLA_PROMISCUITY = 30
    IFLA_NUM_TX_QUEUES = 31
    IFLA_NUM_RX_QUEUES = 32
    IFLA_CARRIER = 33
    IFLA_PHYS_PORT_ID = 34
    IFLA_CARRIER_CHANGES = 35
    IFLA_PHYS_SWITCH_ID = 36
    IFLA_LINK_NETNSID = 37
    IFLA_PHYS_PORT_NAME = 38
    IFLA_PROTO_DOWN = 39
    IFLA_GSO_MAX_SEGS = 40
    IFLA_GSO_MAX_SIZE = 41
    IFLA_PAD = 42
    IFLA_XDP = 43
    IFLA_EVENT = 44
    IFLA_NEW_NETNSID = 45
    IFLA_IF_NETNSID = 46
    IFLA_TARGET_NETNSID = IFLA_IF_NETNSID
    IFLA_CARRIER_UP_COUNT = 47
    IFLA_CARRIER_DOWN_COUNT = 48
    IFLA_NEW_IFINDEX = 49
    IFLA_MIN_MTU = 50
    IFLA_MAX_MTU = 51
    IFLA_PROP_LIST = 52
    IFLA_ALT_IFNAME = 53
    IFLA_PERM_ADDRESS = 54
    IFLA_PROTO_DOWN_REASON = 55
    IFLA_PROTO_DOWN_REASON_UNSPEC = 0
    IFLA_PROTO_DOWN_REASON_MASK = 1
    IFLA_PROTO_DOWN_REASON_VALUE = 2
    IFLA_INET_UNSPEC = 0
    IFLA_INET_CONF = 1
    IFLA_INET6_UNSPEC = 0
    IFLA_INET6_FLAGS = 1
    IFLA_INET6_CONF = 2
    IFLA_INET6_STATS = 3
    IFLA_INET6_MCAST = 4
    IFLA_INET6_CACHEINFO = 5
    IFLA_INET6_ICMP6STATS = 6
    IFLA_INET6_TOKEN = 7
    IFLA_INET6_ADDR_GEN_MODE = 8
    IFLA_BR_UNSPEC = 0
    IFLA_BR_FORWARD_DELAY = 1
    IFLA_BR_HELLO_TIME = 2
    IFLA_BR_MAX_AGE = 3
    IFLA_BR_AGEING_TIME = 4
    IFLA_BR_STP_STATE = 5
    IFLA_BR_PRIORITY = 6
    IFLA_BR_VLAN_FILTERING = 7
    IFLA_BR_VLAN_PROTOCOL = 8
    IFLA_BR_GROUP_FWD_MASK = 9
    IFLA_BR_ROOT_ID = 10
    IFLA_BR_BRIDGE_ID = 11
    IFLA_BR_ROOT_PORT = 12
    IFLA_BR_ROOT_PATH_COST = 13
    IFLA_BR_TOPOLOGY_CHANGE = 14
    IFLA_BR_TOPOLOGY_CHANGE_DETECTED = 15
    IFLA_BR_HELLO_TIMER = 16
    IFLA_BR_TCN_TIMER = 17
    IFLA_BR_TOPOLOGY_CHANGE_TIMER = 18
    IFLA_BR_GC_TIMER = 19
    IFLA_BR_GROUP_ADDR = 20
    IFLA_BR_FDB_FLUSH = 21
    IFLA_BR_MCAST_ROUTER = 22
    IFLA_BR_MCAST_SNOOPING = 23
    IFLA_BR_MCAST_QUERY_USE_IFADDR = 24
    IFLA_BR_MCAST_QUERIER = 25
    IFLA_BR_MCAST_HASH_ELASTICITY = 26
    IFLA_BR_MCAST_HASH_MAX = 27
    IFLA_BR_MCAST_LAST_MEMBER_CNT = 28
    IFLA_BR_MCAST_STARTUP_QUERY_CNT = 29
    IFLA_BR_MCAST_LAST_MEMBER_INTVL = 30
    IFLA_BR_MCAST_MEMBERSHIP_INTVL = 31
    IFLA_BR_MCAST_QUERIER_INTVL = 32
    IFLA_BR_MCAST_QUERY_INTVL = 33
    IFLA_BR_MCAST_QUERY_RESPONSE_INTVL = 34
    IFLA_BR_MCAST_STARTUP_QUERY_INTVL = 35
    IFLA_BR_NF_CALL_IPTABLES = 36
    IFLA_BR_NF_CALL_IP6TABLES = 37
    IFLA_BR_NF_CALL_ARPTABLES = 38
    IFLA_BR_VLAN_DEFAULT_PVID = 39
    IFLA_BR_PAD = 40
    IFLA_BR_VLAN_STATS_ENABLED = 41
    IFLA_BR_MCAST_STATS_ENABLED = 42
    IFLA_BR_MCAST_IGMP_VERSION = 43
    IFLA_BR_MCAST_MLD_VERSION = 44
    IFLA_BR_VLAN_STATS_PER_PORT = 45
    IFLA_BR_MULTI_BOOLOPT = 46
    IFLA_BRPORT_UNSPEC = 0
    IFLA_BRPORT_STATE = 1
    IFLA_BRPORT_PRIORITY = 2
    IFLA_BRPORT_COST = 3
    IFLA_BRPORT_MODE = 4
    IFLA_BRPORT_GUARD = 5
    IFLA_BRPORT_PROTECT = 6
    IFLA_BRPORT_FAST_LEAVE = 7
    IFLA_BRPORT_LEARNING = 8
    IFLA_BRPORT_UNICAST_FLOOD = 9
    IFLA_BRPORT_PROXYARP = 10
    IFLA_BRPORT_LEARNING_SYNC = 11
    IFLA_BRPORT_PROXYARP_WIFI = 12
    IFLA_BRPORT_ROOT_ID = 13
    IFLA_BRPORT_BRIDGE_ID = 14
    IFLA_BRPORT_DESIGNATED_PORT = 15
    IFLA_BRPORT_DESIGNATED_COST = 16
    IFLA_BRPORT_ID = 17
    IFLA_BRPORT_NO = 18
    IFLA_BRPORT_TOPOLOGY_CHANGE_ACK = 19
    IFLA_BRPORT_CONFIG_PENDING = 20
    IFLA_BRPORT_MESSAGE_AGE_TIMER = 21
    IFLA_BRPORT_FORWARD_DELAY_TIMER = 22
    IFLA_BRPORT_HOLD_TIMER = 23
    IFLA_BRPORT_FLUSH = 24
    IFLA_BRPORT_MULTICAST_ROUTER = 25
    IFLA_BRPORT_PAD = 26
    IFLA_BRPORT_MCAST_FLOOD = 27
    IFLA_BRPORT_MCAST_TO_UCAST = 28
    IFLA_BRPORT_VLAN_TUNNEL = 29
    IFLA_BRPORT_BCAST_FLOOD = 30
    IFLA_BRPORT_GROUP_FWD_MASK = 31
    IFLA_BRPORT_NEIGH_SUPPRESS = 32
    IFLA_BRPORT_ISOLATED = 33
    IFLA_BRPORT_BACKUP_PORT = 34
    IFLA_BRPORT_MRP_RING_OPEN = 35
    IFLA_BRPORT_MRP_IN_OPEN = 36
    IFLA_INFO_UNSPEC = 0
    IFLA_INFO_KIND = 1
    IFLA_INFO_DATA = 2
    IFLA_INFO_XSTATS = 3
    IFLA_INFO_SLAVE_KIND = 4
    IFLA_INFO_SLAVE_DATA = 5
    IFLA_VLAN_UNSPEC = 0
    IFLA_VLAN_ID = 1
    IFLA_VLAN_FLAGS = 2
    IFLA_VLAN_EGRESS_QOS = 3
    IFLA_VLAN_INGRESS_QOS = 4
    IFLA_VLAN_PROTOCOL = 5
    IFLA_VLAN_QOS_UNSPEC = 0
    IFLA_VLAN_QOS_MAPPING = 1
    IFLA_MACVLAN_UNSPEC = 0
    IFLA_MACVLAN_MODE = 1
    IFLA_MACVLAN_FLAGS = 2
    IFLA_MACVLAN_MACADDR_MODE = 3
    IFLA_MACVLAN_MACADDR = 4
    IFLA_MACVLAN_MACADDR_DATA = 5
    IFLA_MACVLAN_MACADDR_COUNT = 6
    IFLA_VRF_UNSPEC = 0
    IFLA_VRF_TABLE = 1
    IFLA_VRF_PORT_UNSPEC = 0
    IFLA_VRF_PORT_TABLE = 1
    IFLA_MACSEC_UNSPEC = 0
    IFLA_MACSEC_SCI = 1
    IFLA_MACSEC_PORT = 2
    IFLA_MACSEC_ICV_LEN = 3
    IFLA_MACSEC_CIPHER_SUITE = 4
    IFLA_MACSEC_WINDOW = 5
    IFLA_MACSEC_ENCODING_SA = 6
    IFLA_MACSEC_ENCRYPT = 7
    IFLA_MACSEC_PROTECT = 8
    IFLA_MACSEC_INC_SCI = 9
    IFLA_MACSEC_ES = 10
    IFLA_MACSEC_SCB = 11
    IFLA_MACSEC_REPLAY_PROTECT = 12
    IFLA_MACSEC_VALIDATION = 13
    IFLA_MACSEC_PAD = 14
    IFLA_MACSEC_OFFLOAD = 15
    IFLA_XFRM_UNSPEC = 0
    IFLA_XFRM_LINK = 1
    IFLA_XFRM_IF_ID = 2
    IFLA_IPVLAN_UNSPEC = 0
    IFLA_IPVLAN_MODE = 1
    IFLA_IPVLAN_FLAGS = 2
    IFLA_VXLAN_UNSPEC = 0
    IFLA_VXLAN_ID = 1
    IFLA_VXLAN_GROUP = 2
    IFLA_VXLAN_LINK = 3
    IFLA_VXLAN_LOCAL = 4
    IFLA_VXLAN_TTL = 5
    IFLA_VXLAN_TOS = 6
    IFLA_VXLAN_LEARNING = 7
    IFLA_VXLAN_AGEING = 8
    IFLA_VXLAN_LIMIT = 9
    IFLA_VXLAN_PORT_RANGE = 10
    IFLA_VXLAN_PROXY = 11
    IFLA_VXLAN_RSC = 12
    IFLA_VXLAN_L2MISS = 13
    IFLA_VXLAN_L3MISS = 14
    IFLA_VXLAN_PORT = 15
    IFLA_VXLAN_GROUP6 = 16
    IFLA_VXLAN_LOCAL6 = 17
    IFLA_VXLAN_UDP_CSUM = 18
    IFLA_VXLAN_UDP_ZERO_CSUM6_TX = 19
    IFLA_VXLAN_UDP_ZERO_CSUM6_RX = 20
    IFLA_VXLAN_REMCSUM_TX = 21
    IFLA_VXLAN_REMCSUM_RX = 22
    IFLA_VXLAN_GBP = 23
    IFLA_VXLAN_REMCSUM_NOPARTIAL = 24
    IFLA_VXLAN_COLLECT_METADATA = 25
    IFLA_VXLAN_LABEL = 26
    IFLA_VXLAN_GPE = 27
    IFLA_VXLAN_TTL_INHERIT = 28
    IFLA_VXLAN_DF = 29
    IFLA_GENEVE_UNSPEC = 0
    IFLA_GENEVE_ID = 1
    IFLA_GENEVE_REMOTE = 2
    IFLA_GENEVE_TTL = 3
    IFLA_GENEVE_TOS = 4
    IFLA_GENEVE_PORT = 5
    IFLA_GENEVE_COLLECT_METADATA = 6
    IFLA_GENEVE_REMOTE6 = 7
    IFLA_GENEVE_UDP_CSUM = 8
    IFLA_GENEVE_UDP_ZERO_CSUM6_TX = 9
    IFLA_GENEVE_UDP_ZERO_CSUM6_RX = 10
    IFLA_GENEVE_LABEL = 11
    IFLA_GENEVE_TTL_INHERIT = 12
    IFLA_GENEVE_DF = 13
    IFLA_BAREUDP_UNSPEC = 0
    IFLA_BAREUDP_PORT = 1
    IFLA_BAREUDP_ETHERTYPE = 2
    IFLA_BAREUDP_SRCPORT_MIN = 3
    IFLA_BAREUDP_MULTIPROTO_MODE = 4
    IFLA_PPP_UNSPEC = 0
    IFLA_PPP_DEV_FD = 1
    IFLA_GTP_UNSPEC = 0
    IFLA_GTP_FD0 = 1
    IFLA_GTP_FD1 = 2
    IFLA_GTP_PDP_HASHSIZE = 3
    IFLA_GTP_ROLE = 4
    IFLA_BOND_UNSPEC = 0
    IFLA_BOND_MODE = 1
    IFLA_BOND_ACTIVE_SLAVE = 2
    IFLA_BOND_MIIMON = 3
    IFLA_BOND_UPDELAY = 4
    IFLA_BOND_DOWNDELAY = 5
    IFLA_BOND_USE_CARRIER = 6
    IFLA_BOND_ARP_INTERVAL = 7
    IFLA_BOND_ARP_IP_TARGET = 8
    IFLA_BOND_ARP_VALIDATE = 9
    IFLA_BOND_ARP_ALL_TARGETS = 10
    IFLA_BOND_PRIMARY = 11
    IFLA_BOND_PRIMARY_RESELECT = 12
    IFLA_BOND_FAIL_OVER_MAC = 13
    IFLA_BOND_XMIT_HASH_POLICY = 14
    IFLA_BOND_RESEND_IGMP = 15
    IFLA_BOND_NUM_PEER_NOTIF = 16
    IFLA_BOND_ALL_SLAVES_ACTIVE = 17
    IFLA_BOND_MIN_LINKS = 18
    IFLA_BOND_LP_INTERVAL = 19
    IFLA_BOND_PACKETS_PER_SLAVE = 20
    IFLA_BOND_AD_LACP_RATE = 21
    IFLA_BOND_AD_SELECT = 22
    IFLA_BOND_AD_INFO = 23
    IFLA_BOND_AD_ACTOR_SYS_PRIO = 24
    IFLA_BOND_AD_USER_PORT_KEY = 25
    IFLA_BOND_AD_ACTOR_SYSTEM = 26
    IFLA_BOND_TLB_DYNAMIC_LB = 27
    IFLA_BOND_PEER_NOTIF_DELAY = 28
    IFLA_BOND_AD_INFO_UNSPEC = 0
    IFLA_BOND_AD_INFO_AGGREGATOR = 1
    IFLA_BOND_AD_INFO_NUM_PORTS = 2
    IFLA_BOND_AD_INFO_ACTOR_KEY = 3
    IFLA_BOND_AD_INFO_PARTNER_KEY = 4
    IFLA_BOND_AD_INFO_PARTNER_MAC = 5
    IFLA_BOND_SLAVE_UNSPEC = 0
    IFLA_BOND_SLAVE_STATE = 1
    IFLA_BOND_SLAVE_MII_STATUS = 2
    IFLA_BOND_SLAVE_LINK_FAILURE_COUNT = 3
    IFLA_BOND_SLAVE_PERM_HWADDR = 4
    IFLA_BOND_SLAVE_QUEUE_ID = 5
    IFLA_BOND_SLAVE_AD_AGGREGATOR_ID = 6
    IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE = 7
    IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE = 8
    IFLA_VF_INFO_UNSPEC = 0
    IFLA_VF_INFO = 1
    IFLA_VF_UNSPEC = 0
    IFLA_VF_MAC = 1
    IFLA_VF_VLAN = 2
    IFLA_VF_TX_RATE = 3
    IFLA_VF_SPOOFCHK = 4
    IFLA_VF_LINK_STATE = 5
    IFLA_VF_RATE = 6
    IFLA_VF_RSS_QUERY_EN = 7
    IFLA_VF_STATS = 8
    IFLA_VF_TRUST = 9
    IFLA_VF_IB_NODE_GUID = 10
    IFLA_VF_IB_PORT_GUID = 11
    IFLA_VF_VLAN_LIST = 12
    IFLA_VF_BROADCAST = 13
    IFLA_VF_VLAN_INFO_UNSPEC = 0
    IFLA_VF_VLAN_INFO = 1
    IFLA_VF_LINK_STATE_AUTO = 0
    IFLA_VF_LINK_STATE_ENABLE = 1
    IFLA_VF_LINK_STATE_DISABLE = 2
    IFLA_VF_STATS_RX_PACKETS = 0
    IFLA_VF_STATS_TX_PACKETS = 1
    IFLA_VF_STATS_RX_BYTES = 2
    IFLA_VF_STATS_TX_BYTES = 3
    IFLA_VF_STATS_BROADCAST = 4
    IFLA_VF_STATS_MULTICAST = 5
    IFLA_VF_STATS_PAD = 6
    IFLA_VF_STATS_RX_DROPPED = 7
    IFLA_VF_STATS_TX_DROPPED = 8
    IFLA_VF_PORT_UNSPEC = 0
    IFLA_VF_PORT = 1
    IFLA_PORT_UNSPEC = 0
    IFLA_PORT_VF = 1
    IFLA_PORT_PROFILE = 2
    IFLA_PORT_VSI_TYPE = 3
    IFLA_PORT_INSTANCE_UUID = 4
    IFLA_PORT_HOST_UUID = 5
    IFLA_PORT_REQUEST = 6
    IFLA_PORT_RESPONSE = 7
    IFLA_IPOIB_UNSPEC = 0
    IFLA_IPOIB_PKEY = 1
    IFLA_IPOIB_MODE = 2
    IFLA_IPOIB_UMCAST = 3
    IFLA_HSR_UNSPEC = 0
    IFLA_HSR_SLAVE1 = 1
    IFLA_HSR_SLAVE2 = 2
    IFLA_HSR_MULTICAST_SPEC = 3
    IFLA_HSR_SUPERVISION_ADDR = 4
    IFLA_HSR_SEQ_NR = 5
    IFLA_HSR_VERSION = 6
    IFLA_HSR_PROTOCOL = 7
    IFLA_STATS_UNSPEC = 0
    IFLA_STATS_LINK_64 = 1
    IFLA_STATS_LINK_XSTATS = 2
    IFLA_STATS_LINK_XSTATS_SLAVE = 3
    IFLA_STATS_LINK_OFFLOAD_XSTATS = 4
    IFLA_STATS_AF_SPEC = 5
    IFLA_OFFLOAD_XSTATS_UNSPEC = 0
    IFLA_OFFLOAD_XSTATS_CPU_HIT = 1
    IFLA_XDP_UNSPEC = 0
    IFLA_XDP_FD = 1
    IFLA_XDP_ATTACHED = 2
    IFLA_XDP_FLAGS = 3
    IFLA_XDP_PROG_ID = 4
    IFLA_XDP_DRV_PROG_ID = 5
    IFLA_XDP_SKB_PROG_ID = 6
    IFLA_XDP_HW_PROG_ID = 7
    IFLA_XDP_EXPECTED_FD = 8
    IFLA_EVENT_NONE = 0
    IFLA_EVENT_REBOOT = 1
    IFLA_EVENT_FEATURES = 2
    IFLA_EVENT_BONDING_FAILOVER = 3
    IFLA_EVENT_NOTIFY_PEERS = 4
    IFLA_EVENT_IGMP_RESEND = 5
    IFLA_EVENT_BONDING_OPTIONS = 6
    IFLA_TUN_UNSPEC = 0
    IFLA_TUN_OWNER = 1
    IFLA_TUN_GROUP = 2
    IFLA_TUN_TYPE = 3
    IFLA_TUN_PI = 4
    IFLA_TUN_VNET_HDR = 5
    IFLA_TUN_PERSIST = 6
    IFLA_TUN_MULTI_QUEUE = 7
    IFLA_TUN_NUM_QUEUES = 8
    IFLA_TUN_NUM_DISABLED_QUEUES = 9
    IFLA_RMNET_UNSPEC = 0
    IFLA_RMNET_MUX_ID = 1
    IFLA_RMNET_FLAGS = 2
    IFF_UP = 1<<0
    IFF_BROADCAST = 1<<1
    IFF_DEBUG = 1<<2
    IFF_LOOPBACK = 1<<3
    IFF_POINTOPOINT = 1<<4
    IFF_NOTRAILERS = 1<<5
    IFF_RUNNING = 1<<6
    IFF_NOARP = 1<<7
    IFF_PROMISC = 1<<8
    IFF_ALLMULTI = 1<<9
    IFF_MASTER = 1<<10
    IFF_SLAVE = 1<<11
    IFF_MULTICAST = 1<<12
    IFF_PORTSEL = 1<<13
    IFF_AUTOMEDIA = 1<<14
    IFF_DYNAMIC = 1<<15
    IFF_LOWER_UP = 1<<16
    IFF_DORMANT = 1<<17
    IFF_ECHO = 1<<18
  end
end
