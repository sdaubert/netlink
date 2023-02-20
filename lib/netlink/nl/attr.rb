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
        def decode(data, known_attributes: {}, attribute_names: {})
          nlattr = self.new(known_attributes: known_attributes, attribute_names: attribute_names)
          nlattr.decode(data)
          specific_klass = nlattr.known_attributes[nlattr.type]
          return nlattr if specific_klass.nil?

          nlattr = specific_klass.new(known_attributes: known_attributes, attribute_names: attribute_names)
          nlattr.decode(data)
        end
      end

      def initialize(header: {}, fields: {}, attributes: [], data: '', known_attributes: {}, attribute_names: {})
        super(header: header, fields: fields, attributes: attributes, data: data)
        @known_attributes = known_attributes
        @attribute_names = attribute_names
      end

      def align
        4
      end

      def length
        header.length
      end

      def padded_length
        real = length
        padded = -(real % -align)
        real + padded
      end

      def type
        header.type
      end

      def human_type
        attribute_names[type] || type
      end

      def value
        fields&.value || @data.b
      end

      def inspect
        type_str = human_type.inspect
        "#<#{self.class} type=#{type_str}, length=#{length}, value=#{value.inspect}"
      end

      class Unspec < Attr; end

      class U8 < Attr
        define_fields value: 'C'
      end

      class U16 < Attr
        define_fields value: 'S'
      end

      class U32 < Attr
        define_fields value: 'L'
      end

      class U64 < Attr
        define_fields value: 'Q'
      end

      # Null-terminated string
      class String < Attr
        define_fields value: 'Z*'
      end

      class MacAddr < Attr
        define_fields value: 'C6'

        def decode_fields(data)
          fields.value = data.unpack(self.class.fields.values.first).map { |v| '%02x' % v }.join(':')
          padded_length
        end

        def encode_fields
          pad(fields.value.split(':').map { |v| v.to_i(16) }.pack(self.class.fields.values.first))
        end
      end
    end
  end
end
