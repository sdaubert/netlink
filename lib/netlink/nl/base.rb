# frozen_string_literal: true

module Netlink
  module Nl
    # Base class for netlink protocol data
    # @abstract Subclasses should define header, fields and/or attributes through {.define_header}, {.define_fields} and {.define_attributes}.
    class Base
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

        def attributes_from_number
          @attributes_from_number ||= {}
        end

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
          @attributes_from_number = kwargs.keys.to_h { |name| [Constants.const_get("#{prefix}#{name.to_s.upcase}"), kwargs[name]] }
          @attribute_names_from_number = kwargs.keys.to_h { |name| [Constants.const_get("#{prefix}#{name.to_s.upcase}"), name] }
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
            @fields = parent.fields.dup
            # @attributes = parent.attributes.dup
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

      def initialize(header: {}, fields: {}, attributes: {}, data: '')
        @header = create_struct(:header, header)
        @fields = create_struct(:fields, fields)
        @attributes = attributes
        @data = data
      end

      # Encode message
      # @param [String,nil]] data supplementary data to add to message
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
        fields_size = decode_fields(data[header_size..])
        preambule_size = header_size + fields_size
        if self.class.attributes.empty?
          @data = data[preambule_size..]&.b
        else
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

      private

      def create_struct(type, values)
        members = self.class.send(type).keys
        return if members.empty?

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
        @attributes.map { |nla| pad(nla.encode) }.join
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
          data = data[nla.padded_length..]
          size += nla.padded_length
          @attributes[nla.human_type] = nla
        end

        size
      end

      # @param [Hash<Symbol, String>] klass_def
      # @param [Hash<Symbol, Integer>] values
      # @param [String] data
      # @return [Integer] size of padded decoded data
      def base_decode(klass_def, values, data)
        return 0 if klass_def.empty?

        pack_str = klass_def.values.join
        ary = data.unpack(pack_str)
        size = pad(ary.pack(pack_str)).size
        values.members.each { |m| values[m] = ary.shift }

        size
      end
    end
  end
end
