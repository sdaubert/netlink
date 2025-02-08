# frozen_string_literal: true

module Netlink
  module Nl
    # Handles a set of Netlink attributes
    class Attributes
      include BinStruct::Structable

      # Unspecified attribute
      Unspec = BinStruct::AbstractTLV.create
      # Unsigned 8-bit integer attribute
      U8 = BinStruct::AbstractTLV.create(type_class: Int16n, length_class: Int16n, value_class: BinStruct::Int8, attr_in_length: 'LV', attr_order: 'LTV')
      # Unsigned 16-bit integer attribute
      U16 = BinStruct::AbstractTLV.create(type_class: Int16n, length_class: Int16n, value_class: Int16n, attr_in_length: 'LV', attr_order: 'LTV')
      # Unsigned 32-bit integer attribute
      U32 = BinStruct::AbstractTLV.create(type_class: Int16n, length_class: Int16n, value_class: Int32n, attr_in_length: 'LV', attr_order: 'LTV')
      # Unsigned 64-bit integer attribute
      U64 = BinStruct::AbstractTLV.create(type_class: Int16n, length_class: Int16n, value_class: Int64n, attr_in_length: 'LV', attr_order: 'LTV')
      # Null-terminated string
      String = BinStruct::AbstractTLV.create(type_class: Int16n, length_class: Int16n, value_class: BinStruct::CString, attr_in_length: 'LV', attr_order: 'LTV')
      # MAC address attribute
      MacAddr = BinStruct::AbstractTLV.create(type_class: Int16n, length_class: Int16n, value_class: BinStruct::ArrayOfInt8, attr_in_length: 'LV', attr_order: 'LTV')

      # class LinkInfo < Attr
      #   define_attributes prefix: 'IFLA_INFO_',
      #                     kind: String,
      #                     data: Unspec

      #   def initialize(header: {}, fields: {}, attributes: {}, data: '', known_attributes: {}, attribute_names: {})
      #     header[:type] ||= Constants::IFLA_LINKINFO
      #     super
      #   end

      #   # @return [String]
      #   def inspect
      #     type_str = human_type.inspect
      #     "#<#{self.class} type=#{type_str}, length=#{length}, value=#{attributes.inspect}"
      #   end
      # end

      def initialize(prefix:, known: {})
        @known_attributes = known
        @known_attribute_numbers = known.keys.to_h { |name| [Constants.const_get("#{prefix}#{name.to_s.upcase}").to_i, name] }
        @attributes = {}
      end

      def read(str)
        until str.empty?

        end
      end

      def to_human
        ''
      end

      def to_s
        @attributes.map(&:to_s).join
      end
    end
  end
end
