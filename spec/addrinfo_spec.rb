# frozen_string_literal: true

module Netlink
  RSpec.describe Addrinfo do
    describe '.new' do
      it 'accepts a sockaddr_nl (String)' do
        ai = Addrinfo.new("\x10\x00\x00\x00\x21\x43\x65\x87\x01\x00\x00\x00".b)
        expect(ai.afamily).to eq(Socket::AF_NETLINK)
        expect(ai.pid).to eq(0x87654321)
        expect(ai.groups).to eq(1)
      end

      it 'accepts an Array' do
        ai = Addrinfo.new(['AF_NETLINK', 0x87654321, 1])
        expect(ai.afamily).to eq(Socket::AF_NETLINK)
        expect(ai.pid).to eq(0x87654321)
        expect(ai.groups).to eq(1)

        ai = Addrinfo.new([Socket::AF_NETLINK, 0x87654321, 1])
        expect(ai.afamily).to eq(Socket::AF_NETLINK)
      end

      it 'raises on other types' do
        expect { Addrinfo.new(10) }.to raise_error(TypeError)
      end
      it 'raises on String with wrong socket family' do
        sockaddr_nl = "\x11\x00\x00\x00\x21\x43\x65\x87\x01\x00\x00\x00".b
        expect { Addrinfo.new(sockaddr_nl) }.to raise_error(SocketError)
      end

      it 'raises on Array with wrong socket family' do
        expect { Addrinfo.new(['AF_UNIX', '/tmp/sock']) }.to raise_error(SocketError)
      end

      it 'raises on Array with second element not an integer' do
        expect { Addrinfo.new(['AF_NETLINK', '1', 0]) }.to raise_error(TypeError)
      end

      it 'raises on Array with third element not an integer' do
        expect { Addrinfo.new(['AF_NETLINK', 1, '0']) }.to raise_error(TypeError)
      end
    end
  end
end
