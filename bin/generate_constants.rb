#!/usr/bin/ruby -w
# frozen_string_literal: true

BaseDir = File.absolute_path(File.dirname(__dir__))

def generate_constants_from_define(io, const_base, file)
  IO.popen("grep \"#define #{const_base}\" /usr/include/#{file}") do |gio|
    gio.each_line do |line|
      _def, name, value, *comment = line.strip.split
      next if name.nil?
      next if name.end_with?('_H')
      next if block_given? && (yield name)

      comment = comment[1..-2]&.join(' ')

      io.puts("    # #{comment}") unless comment.nil?
      io.puts("    #{name} = #{value}")
    end
  end
end

# TODO: rewrite it to handle multi enum in one file:
#  * read all lines
#  * start on line with enum {
#  * end on line with }
def generate_constants_from_enum(io, const_base, file)
  File.open("/usr/include/#{file}") do |f|
    analyze = false
    previous_value = -1
    until f.eof?
      line = f.readline
      if line.include?('enum') && line.include?('{')
        analyze = true
        previous_value = -1
      elsif analyze
        name, _equal, value, *_comment = line.strip.split
        next if name.nil?

        if name.include?('};')
          analyze = false
          next
        end
        next if name.start_with?('#')
        next unless name.start_with?(const_base)
        next if block_given? && (yield name)

        if name.end_with?(',')
          previous_value += 1
          value = previous_value
          name.chop!
          # comment = [equal, value].concat(comment)
        else
          previous_value = value.to_i unless value.start_with?(const_base)
          value.chop! if value.end_with?(',')
        end
        # comment = comment[1..-2]&.join(' ')

        # io.puts("    # #{comment}") unless comment.nil?
        io.puts("    #{name} = #{value}")
      end
    end
  end
end

def generate_netlink_constants(io)
  generate_constants_from_define(io, 'NETLINK_', 'linux/netlink.h')
end

def generate_nlm_constants(io)
  generate_constants_from_define(io, 'NLM_', 'linux/netlink.h')
end

def generate_nlmsg_constants(io)
  filter = %w[ALIGN HDRLEN LENGTH SPACE DATA NEXT OK PAYLOAD MIN_TYPE]
  generate_constants_from_define(io, 'NLMSG_', 'linux/netlink.h') do |name|
    filter.any? { |word| name.include?(word) }
  end
end

def generate_rtm_constants(io)
  generate_constants_from_enum(io, 'RTM_', 'linux/rtnetlink.h') do |name|
    (name == 'RTM_BASE') || (name == '__RTM_MAX')
  end
end

def generate_ifla_constants(io)
  generate_constants_from_enum(io, 'IFLA_', 'linux/if_link.h') do |name|
    name.start_with?('__') || name.end_with?('MAX')
  end
end

def generate_if_constants(io)
  generate_constants_from_enum(io, 'IFF_', 'linux/if.h')
  generate_constants_from_enum(io, 'IF_OPER', 'linux/if.h')
end

filename = File.join(BaseDir, 'lib', 'netlink', 'constants.rb')
puts "Create #{filename}"
File.open(filename, 'w') do |f|
  f.write("# frozen_string_literal: true\n\n")
  f.write("module Netlink\n  module Constants\n")

  generate_netlink_constants(f)
  generate_nlm_constants(f)
  generate_nlmsg_constants(f)
  generate_rtm_constants(f)
  generate_ifla_constants(f)
  generate_if_constants(f)

  f.write("  end\nend\n")
end
