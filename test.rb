require 'netlink'

sock = Netlink::Socket.new(Netlink::NETLINK_ROUTE)
p sock

ai1 = Netlink::Addrinfo.new(sock.addr)
p ai1

ai2 = Netlink::Addrinfo.new(Netlink::Socket.sockaddr_nl(ai1.pid + 1, 0))
p ai2

# p sock.bind(ai1)
# p sock.bind(ai2)

hdr = Netlink::NlMsgHdr.new(0, Netlink::NLMSG_NOOP, Netlink::NLM_F_ECHO | Netlink::NLM_F_ACK, 1, ai1.pid)
p sock.sendmsg('', 0, hdr, Netlink::Addrinfo.new(['AF_NETLINK', 0, 0]))
p sock.recvmsg()
