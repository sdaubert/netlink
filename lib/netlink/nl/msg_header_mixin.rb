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

      def flag_multi?
        case flags
        when Array
          flags.include?(:multi) || flags.include?(Constants::NLM_F_MULTI)
        when Integer
          (flags & Constants::NLM_F_MULTI) == Constants::NLM_F_MULTI
        else
          false
        end
      end
    end
  end
end
