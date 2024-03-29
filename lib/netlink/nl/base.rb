# frozen_string_literal: true

module Netlink
  module Nl
    # Base class for netlink protocol data
    # @abstract Subclasses should define header, fields and/or attributes through {.define_header}, {.define_fields} and {.define_attributes}.
    class Base
      # @private
      VoidStruct = Struct.new(:value)

      class << self
        # @return [Hash<Symbol, String>]
        def header
          @header ||= {}
        end

        # @return [Hash<Symbol, String>]
        def fields
          @fields ||= {}
        end

        # @return [Hash<Symbol, Class>]
        def attributes
          @attributes ||= {}
        end

        # @return [Hash<Integer,Class>]
        def attributes_from_number
          @attributes_from_number ||= {}
        end

        # @return [Hash<Integer,Symbol>]
        def attribute_names_from_number
          @attribute_names_from_number ||= {}
        end

        # Define header
        # @param [Hash<Symbol,String>] kwargs keys are header field name, and values are their pack string
        # @return [void]
        def define_header(**kwargs)
          @header = kwargs
          keys = kwargs.keys << :msg
          self.const_set(:Header, Struct.new(*keys, keyword_init: true))
        end

        # Define fields
        # @param [Hash<Symbol,String>] kwargs keys are field name, and values are their pack string
        # @return [void]
        def define_fields(**kwargs)
          @fields = kwargs
          keys = kwargs.keys << :msg
          self.const_set(:Fields, Struct.new(*keys, keyword_init: true))
        end

        # Define attributes
        # @param [Hash<Symbol,Class>] kwargs keys are attribute name, and values are {Attr} subclasses
        # @return [void]
        def define_attributes(prefix:, **kwargs)
          @attributes = kwargs
          @attributes_from_number = kwargs.keys.to_h { |name| [Constants.const_get("#{prefix}#{name.to_s.upcase}").to_i, kwargs[name]] }
          @attribute_names_from_number = kwargs.keys.to_h { |name| [Constants.const_get("#{prefix}#{name.to_s.upcase}").to_i, name] }
        end

        # Align parameter, as bytes
        # @return [Integer]
        def align
          4
        end

        # On inheritage, set class variables from parent
        # @param [Class] subclass
        # @return [void]
        def inherited(subclass)
          super
          parent = self
          subclass.class_eval do
            @header = parent.header.dup
            @fields = parent.fields.dup
          end
        end
      end

      # @return [Struct]
      attr_reader :header
      # @return [Struct]
      attr_reader :fields
      # @return [Hash<Symbol,Attr>]
      attr_reader :attributes
      # Supplementary data
      # @return [String]
      attr_reader :data

      # @param [Hash] header
      # @param [Hash] fields
      # @param [Hash] attributes
      # @param [String] data
      def initialize(header: {}, fields: {}, attributes: {}, data: '')
        initialize_header(header)
        initialize_fields(fields)
        @attributes = attributes
        @data = data
      end

      # Encode message
      # @param [String,nil] data supplementary data to add to message
      # @return [String] encoded netlink data as binary String
      def encode(data=nil)
        str = encode_content(data)
        encode_header(str) << str
      end

      # Encode message content. i.e. encode fields, attributes and supplementary data
      # @param [String,nil] data supplementary data to add to message
      # @return [String] encoded netlink data as binary String
      def encode_content(data=nil)
        data ||= @data
        encode_fields << encode_attributes << pad(data)
      end

      # Decode netlink data from a binary String
      # @param [String] data
      # @return [self]
      def decode(data)
        header_size = decode_header(data)
        data = data[0...header.length]
        fields_size = decode_fields(data&.slice(header_size..))
        preambule_size = header_size + fields_size
        if self.class.attributes.empty?
          @data = data&.slice(preambule_size..)&.b || ''
        elsif !data.nil?
          decode_attributes(data[preambule_size..])
        end
        self
      end

      # Add padding to given +data+
      # @param [String] data
      # @return [String]
      def pad(data)
        data.b << "\x00" * -(data.size % -self.class.align)
      end

      # Add/modify an attribute
      # @param [Symbol] kind attribute type
      # @param [Object] value attribute value
      def add_attribute(kind, value)
        kind_int = self.class.attribute_names_from_number.key(kind)
        raise ArgumentError, "Unknown attribute type #{kind.inspect}" if kind_int.nil?

        attr_klass = self.class.attributes_from_number[kind_int]
        attributes[kind] = attr_klass.new(header: { type: kind_int }, fields: { value: value })
      end

      private

      def initialize_header(header)
        @header = create_struct(:header, header)
      end

      def initialize_fields(fields)
        @fields = create_struct(:fields, fields)
      end

      def create_struct(type, values)
        members = self.class.send(type).keys
        return VoidStruct.new(nil) if members.empty?

        default_values = members.to_h { |m| [m, 0] }
        default_values[:msg] = self
        klass = self.class.const_get(type.capitalize)
        klass.new(default_values.merge(values))
      end

      # @param [String] _body body of message
      # @return [String]
      def encode_header(_body)
        base_encode(self.class.header, header)
      end

      def encode_fields
        base_encode(self.class.fields, fields)
      end

      def encode_attributes
        @attributes.values.map { |nla| pad(nla.encode) }.join
      end

      # @param [Hash<Symbol, String>] klass_def
      # @param [Hash<Symbol, Integer>] values
      def base_encode(klass_def, values)
        return +'' if klass_def.empty?

        ary = []
        pack_str = +''
        klass_def.each do |key, pack|
          ary << values[key]
          pack_str << pack
        end

        pad(ary.pack(pack_str))
      end

      def decode_header(data)
        base_decode(self.class.header, header, data)
      end

      def decode_fields(data)
        base_decode(self.class.fields, fields, data)
      end

      def decode_attributes(data)
        size = 0

        until data.nil? || data.empty?
          nla = Attr.decode(data,
                            known_attributes: self.class.attributes_from_number,
                            attribute_names: self.class.attribute_names_from_number)
          data = data[nla.padded_length..].to_s
          size += nla.padded_length
          nla_name = nla.human_type

          @attributes[nla_name] = nla
        end

        size
      end

      def base_decode(klass_def, values, data)
        return 0 if klass_def.empty?
        return 0 if data.nil?

        pack_str = klass_def.values.join
        ary = data.unpack(pack_str)
        size = pad(ary.pack(pack_str)).size
        values.members.each { |m| values[m] = ary.shift }

        size
      end
    end
  end
end
