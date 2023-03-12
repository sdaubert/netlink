# frozen_string_literal: true

module Netlink
  module Nl
    # Mixin for {Msg} headers
    module MsgHeaderMixin
      # Return human readable type (if possible)
      # @return [String, Integer]
      def human_type
        @types.key(type).to_s || type
      end

      # @return [String]
      def inspect
        "#<#{self.class} length=#{length}, type=#{human_type.inspect}, flags=#{flags}, seq=#{seq}, pid=#{pid}>"
      end

      # @param [Hash<Symbol, Integer>] types
      def types=(types)
        @types = types
      end
    end
  end
end
