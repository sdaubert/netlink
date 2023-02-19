#!/usr/bin/ruby -w
# frozen_string_literal: true

BaseDir = File.absolute_path(File.dirname(__dir__))

def generate_constants_from_define(io, const_base, file)
  IO.popen("grep \"#define #{const_base}\" /usr/include/#{file}") do |gio|
    gio.each_line do |line|
      _def, name, value, *comment = line.strip.split
      next if name.nil?
      next if name.end_with?('_H')

      comment = comment[1..-2]&.join(' ')

      io.puts("    # #{comment}") unless comment.nil?
      io.puts("    #{name} = #{value}")
    end
  end
end

def generate_constants_from_enum(io, const_base, file)
  IO.popen("grep -E '#{const_base}[[:alnum:]_]+[[:space:]]+=' /usr/include/#{file}") do |gio|
    gio.each_line do |line|
      name, _equal, value, *comment = line.strip.split
      next if name.nil?
      next if block_given? && (yield name)

      comment = comment[1..-2]&.join(' ')

      io.puts("    # #{comment}") unless comment.nil?
      io.puts("    #{name} = #{value[0...-1]}")
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
  IO.popen('grep NLMSG_ /usr/include/linux/netlink.h') do |gio|
    gio.each_line do |line|
      _def, name, value, *comment = line.strip.split
      ivalue = value.to_i(16)
      next if ivalue <= 0
      next if ivalue >= 16

      comment = comment[1..-2]&.join(' ')
      io.puts("    # #{comment}") unless comment.nil?
      io.puts("    #{name} = #{ivalue}")
    end
  end
end

def generate_rtm_constants(io)
  generate_constants_from_enum(io, 'RTM_', 'linux/rtnetlink.h') do |name|
    name == 'RTM_BASE'
  end
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

  f.write("  end\nend\n")
end
