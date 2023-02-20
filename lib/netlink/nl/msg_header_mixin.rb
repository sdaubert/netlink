# frozen_string_literal: true

module Netlink
  module Nl
    module MsgHeaderMixin
      def human_type
        @types.key(type) || type
      end

      def inspect
        "#<#{self.class} length=#{length}, type=#{human_type.inspect}, flags=#{flags}, seq=#{seq}, pid=#{pid}>"
      end

      def types=(types)
        @types = types
      end
    end
  end
end
