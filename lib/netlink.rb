# frozen_string_literal: true

require_relative 'netlink/version'

# Pure ruby netlink library
module Netlink
  # Base class for Netlink errors
  class Error < StandardError; end
  # Error when using {Socket}
  class SocketError < Error; end
  # Error on Netlink messages (a {Nl::MsgError} was received)
  class NlmError < Error; end

  # Routing/device hook
  NETLINK_ROUTE	=	0
  # Reserved for user mode socket protocols
  NETLINK_USERSOCK = 2
  # socket monitoring
  NETLINK_SOCK_DIAG = 4
  NETLINK_INET_DIAG =	NETLINK_SOCK_DIAG
  # netfilter/iptables ULOG
  NETLINK_NFLOG	=	5
  # ipsec
  NETLINK_XFRM	=	6
  # SELinux event notifications
  NETLINK_SELINUX	=	7
  # Open-iSCSI
  NETLINK_ISCSI	=	8
  # auditing
  NETLINK_AUDIT	=	9
  NETLINK_FIB_LOOKUP = 10
  NETLINK_CONNECTOR = 11
  # netfilter subsystem
  NETLINK_NETFILTER = 12
  NETLINK_IP6_FW	=	13
  # DECnet routing messages
  NETLINK_DNRTMSG	=	14
  # Kernel messages to userspace
  NETLINK_KOBJECT_UEVENT	= 15
  NETLINK_GENERIC	=	16
  # SCSI Transports
  NETLINK_SCSITRANSPORT	= 18
  NETLINK_ECRYPTFS = 19
  NETLINK_RDMA = 20
  # Crypto layer
  NETLINK_CRYPTO = 21
  # SMC monitoring
  NETLINK_SMC = 22

  # Must be set on all request messages.
  NLM_F_REQUEST = 0x01
  # The message is part of a multipart message terminated by NLMSG_DONE.
  NLM_F_MULTI = 0x02
  # Request for an acknowlegement on succes.
  NLM_F_ACK = 0x04
  # Echo this request.
  NLM_F_ECHO = 0x08

  NLMSG_NOOP = 1
  NLMSG_ERROR = 2
  NLMSG_DONE = 3
end

require_relative 'netlink/nl'
require_relative 'netlink/addrinfo'
require_relative 'netlink/socket'
