# frozen_string_literal: true

require_relative 'netlink/version'
require_relative 'netlink/constants'

# Pure ruby netlink library
module Netlink
  include Constants

  # Base class for Netlink errors
  class Error < StandardError; end
  # Error when using {Socket}
  class SocketError < Error; end
  # Error on Netlink messages (a {Nl::MsgError} was received)
  class NlmError < Error; end
end

require_relative 'netlink/nl'
require_relative 'netlink/addrinfo'
require_relative 'netlink/socket'
require_relative 'netlink/route'
