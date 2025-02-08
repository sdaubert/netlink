# frozen_string_literal: true

module Netlink
  module Nl
    # @!parse
    #  # Base attribute class
    #  # @abstract
    #  class Attr < BinStruct::AbstractTLV; end
    Attr = BinStruct::AbstractTLV.create(type_class: Int16n, length_class: Int16n, attr_order: 'LTV')

    class Attr
      # @!parse
      #  # Unspecified attribute
      #  class Unspec < Attr; end
      Unspec = Attr.derive
      # @!parse
      #  # Unsigned 8-bit integer attribute
      #  class Unspec < Attr; end
      U8 = Attr.derive(value_class: BinStruct::Int8)
      # @!parse
      #  # Unsigned 16-bit integer attribute
      #  class Unspec < Attr; end
      U16 = Attr.derive(value_class: Int16n)
      # @!parse
      #  # Unsigned 32-bit integer attribute
      #  class Unspec < Attr; end
      U32 = Attr.derive(value_class: Int32n)
      # @!parse
      #  # Unsigned 64-bit integer attribute
      #  class Unspec < Attr; end
      U64 = Attr.derive(value_class: Int64n)
      # @!parse
      #  # Null-terminated string
      #  class Unspec < Attr; end
      String = Attr.derive(value_class: BinStruct::CString)
      # @!parse
      #  # MAC address attribute
      #  class Unspec < Attr; end
      MacAddr = Attr.derive(value_class: BinStruct::ArrayOfInt8)
    end

    # Handles a set of Netlink attributes
    class Attributes < BinStruct::Array
      set_of Attr
    end
  end
end
