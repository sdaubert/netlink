# frozen_string_literal: true

module Netlink
  # Namespace for all low-level netlink protocol data
  module Nl
  end
end

require_relative 'nl/base'
require_relative 'nl/msg'
require_relative 'nl/msg_error'
