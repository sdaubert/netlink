# frozen_string_literal: true

module Netlink
  module Nl
    # Base class for netlink protocol data
    # @abstract Subclasses should define header, fields and/or attributes through {.define_header}, {.define_fields} and {.define_attributes}.
    class Base
      class << self
        # @return [Class]
        attr_reader :header_class
        # @return [Class]
        attr_reader :fields_class
        # @return [Class]
        attr_reader :attributes_class

        # @return [Hash<Symbol, String>]
        def header
          @header ||= {}
        end

        # @return [Hash<Symbol, String>]
        def fields
          @fields ||= {}
        end

        # @return [Hash<Symbol, String>]
        def attributes
          @attributes ||= {}
        end

        # Define header
        # @param [Hash<Symbol,String>] kwargs keys are header field name, and values are their pack string
        # @return [void]
        def define_header(**kwargs)
          @header = kwargs
          @header_class = Struct.new(*kwargs.keys, keyword_init: true)
        end

        # Define fields
        # @param [Hash<Symbol,String>] kwargs keys are field name, and values are their pack string
        # @return [void]
        def define_fields(**kwargs)
          @fields = kwargs
          @fields_class = Struct.new(*kwargs.keys, keyword_init: true)
        end

        # Define attributes
        # @param [Hash<Symbol,String>] kwargs keys are attribute name, and values are their pack string
        # @return [void]
        def define_attributes(**kwargs)
          @attributes = kwargs
          @attributes_class = Struct.new(*kwargs.keys, keyword_init: true)
        end

        # Align parameter, as bytes
        # @return [Integer]
        def align
          4
        end

        # On inheritage, set class variables from parent
        # @param [Class] klass
        # @return [void]
        def inherited(klass)
          super
          parent = self
          klass.class_eval do
            @header = parent.header.dup
            @header_class = parent.header_class
            @fields = parent.fields.dup
            @fields_class = parent.fields_class
            @attributes = parent.attributes.dup
            @attributes_class = parent.attributes_class
          end
        end
      end

      # @return [Struct]
      attr_reader :header
      # @return [Struct]
      attr_reader :fields
      # @return [Struct]
      attr_reader :attributes

      def initialize(header: {}, fields: {}, attributes: {})
        @header = create_struct(:header, header)
        @fields = create_struct(:fields, fields)
        @attributes = create_struct(:attributes, attributes)
      end

      # Encode message
      # @param [String] data supplementary data to add to message
      # @return [String] encoded netlink data as binary String
      def encode(data='')
        str = encode_content(data)
        encode_header << str
      end

      # Encode message content. i.e. encode fields, attributes and supplementary data
      # @param [String] data supplementary data to add to message
      # @return [String] encoded netlink data as binary String
      def encode_content(data='')
        encode_fields << encode_attributes << pad(data)
      end

      # Decode netlink data from a binary String
      # @param [String] data
      # @return [self]
      def decode(data)
        header_size = base_decode(self.class.header, header, data)
        fields_size = base_decode(self.class.fields, fields, data[header_size..])
        no_attr_size = header_size + fields_size
        base_decode(self.class.attributes, attributes, data[no_attr_size..])
        self
      end

      # Add padding to given +data+
      # @param [String] data
      # @return [String]
      def pad(data)
        data.b << "\x00" * -(data.size % -self.class.align)
      end

      private

      def create_struct(type, values)
        members = self.class.send(type).keys
        return if members.empty?

        default_values = members.to_h { |m| [m, 0] }
        klass = self.class.send("#{type}_class".to_sym)
        klass.new(default_values.merge(values))
      end

      def encode_header
        base_encode(self.class.header, header)
      end

      def encode_fields
        base_encode(self.class.fields, fields)
      end

      def encode_attributes
        base_encode(self.class.attributes, attributes)
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

      # @param [Hash<Symbol, String>] klass_def
      # @param [Hash<Symbol, Integer>] values
      # @param [String] data
      # @return [Integer] size of padded decoded data
      def base_decode(klass_def, values, data)
        return 0 if klass_def.empty?

        pack_str = klass_def.values.join
        ary = data.unpack(pack_str)
        values.members.each { |m| values[m] = ary.shift }

        pad(([0] * pack_str.size).pack(pack_str)).size
      end
    end
  end
end
