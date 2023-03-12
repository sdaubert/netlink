# frozen_string_literal: true

module Netlink
  module Nl
    # Base Netlink attribute
    class Attr < Base
      # @private
      attr_reader :known_attributes
      # @private
      attr_reader :attribute_names

      define_header length: 'S', type: 'S'

      class << self
        # Decode an attribute from a binary string
        # @param [String] data
        # @param [Hash<Integer,Class>] known_attributes
        # @param [Hash<Integer,Symbol>] attribute_names
        # @return [Attr]
        def decode(data, known_attributes: {}, attribute_names: {})
          nlattr = self.new(known_attributes: known_attributes, attribute_names: attribute_names)
          nlattr.decode(data)
          specific_klass = known_attributes[nlattr.type]
          return nlattr if specific_klass.nil?

          nlattr = specific_klass.new(known_attributes: known_attributes, attribute_names: attribute_names)
          nlattr.decode(data)
        end
      end

      # @see Base#initialize
      # @param [Hash<Integer,Class>] known_attributes
      # @param [Hash<Integer,Symbol>] attribute_names
      def initialize(header: {}, fields: {}, attributes: [], data: '', known_attributes: {}, attribute_names: {})
        super(header: header, fields: fields, attributes: attributes, data: data)
        @known_attributes = known_attributes
        @attribute_names = attribute_names
      end

      # @return [Integer]
      def align
        4
      end

      # @return [Integer]
      def length
        header.length
      end

      # @return [Integer]
      def padded_length
        real = length
        padded = -(real % -align)
        real + padded
      end

      # @return [Integer]
      def type
        header.type
      end

       # @return [String,Integer]
      def human_type
        attribute_names[type].to_s || type
      end

      # Return current value of attribute
      def value
        fields&.value || @data.b
      end

      # @return [String]
      def inspect
        type_str = human_type.inspect
        "#<#{self.class} type=#{type_str}, length=#{length}, value=#{value.inspect}"
      end

      # Unspecified attribute
      class Unspec < Attr; end

      # Unsigned 8-bit integer attribute
      class U8 < Attr
        define_fields value: 'C'
      end

      # Unsigned 16-bit integer attribute
      class U16 < Attr
        define_fields value: 'S'
      end

      # Unsigned 32-bit integer attribute
      class U32 < Attr
        define_fields value: 'L'
      end

      # Unsigned 64-bit integer attribute
      class U64 < Attr
        define_fields value: 'Q'
      end

      # Null-terminated string
      class String < Attr
        define_fields value: 'Z*'
      end

      # MAC address attribute
      class MacAddr < Attr
        define_fields value: 'C6'

        private

        def decode_fields(data)
          fields.value = data.unpack(self.class.fields.values.first.to_s).map { |v| '%02x' % v.to_s }.join(':')
          padded_length
        end

        def encode_fields
          pad(fields.value.split(':').map { |v| v.to_i(16) }.pack(self.class.fields.values.first))
        end
      end
    end
  end
end
