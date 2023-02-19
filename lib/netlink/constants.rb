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
    # Multipart message, terminated by NLMSG_DONE
    NLM_F_MULTI = 2
    NLMSG_ALIGNTO = 4
    # Nothing.
    NLMSG_NOOP = 1
    # Error
    NLMSG_ERROR = 2
    # End of a dump
    NLMSG_DONE = 3
    # Data lost
    NLMSG_OVERRUN = 4
    RTM_NEWLINK = 16
    RTM_NEWADDR = 20
    RTM_NEWROUTE = 24
    RTM_NEWNEIGH = 28
    RTM_NEWRULE = 32
    RTM_NEWQDISC = 36
    RTM_NEWTCLASS = 40
    RTM_NEWTFILTER = 44
    RTM_NEWACTION = 48
    RTM_NEWPREFIX = 52
    RTM_GETMULTICAST = 58
    RTM_GETANYCAST = 62
    RTM_NEWNEIGHTBL = 64
    RTM_GETNEIGHTBL = 66
    RTM_NEWNDUSEROPT = 68
    RTM_NEWADDRLABEL = 72
    RTM_GETDCB = 78
    RTM_NEWNETCONF = 80
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
    RTM_NEWNEXTHOP = 104
    RTM_NEWLINKPROP = 108
    RTM_NEWVLAN = 112
  end
end
