# frozen_string_literal: true

module Netlink
  # Route Module to handle Route family netlink protocols
  module Route
    # Get links
    # @see Link.get
    def self.links
      Link.get
    end
  end
end

require_relative 'route/link'
