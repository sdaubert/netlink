# frozen_string_literal: true

module Netlink
  RSpec.describe Socket do
    describe '.generate_pid' do
      it 'generate a port id' do
        expect(Socket.generate_pid).to be_a(Integer)
      end

      it 'generates different pid' do
        pid1 = Socket.generate_pid
        pid2 = Socket.generate_pid
        expect(pid1).not_to eq(pid2)
      end
    end

    describe '.sockaddr_nl' do
      it 'packs netlink socket info into a sockaddr_nl' do
        sanl = Socket.sockaddr_nl(22000, 5)
        expect(sanl).to eq("\x10\x00\x00\x00\xf0\x55\x00\x00\x05\x00\x00\x00".b)
      end
    end

    describe '.new' do
      it 'accepts a family parameter' do
        sock = Socket.new(NETLINK_ROUTE)
        expect(sock.inspect).to match(/AF_NETLINK, #{NETLINK_ROUTE}/)
      end
      it 'accepts a block' do
        sock = nil
        Socket.new(NETLINK_ROUTE) { |sk| sock = sk }
        expect(sock).to be_a(Socket)
      end
    end

    describe '#addr' do
      let(:sock) { Socket.new(NETLINK_ROUTE) }

      it 'returns an Array of 3 elements' do
        addr = sock.addr
        expect(addr).to be_a(Array)
        expect(addr.size).to eq(3)
      end

      it "'s first element is the string AF_NETLINK" do
        expect(sock.addr[0]).to eq('AF_NETLINK')
      end

      it "'s second element is the socket pid" do
        expect(sock.addr[1]).to be_a(Integer)
      end

      it "'s thirs element is 0" do
        expect(sock.addr[2]).to eq(0)
      end
    end

    it 'binds a local address' do
      Socket.new(NETLINK_ROUTE) do |sock|
        expect { sock.bind(0)}.not_to raise_error
      end
    end

    describe '#sendmsg' do
      it 'sends data over socket', :sudo do
        data = 'Hello World!'
        Socket.new(NETLINK_GENERIC) do |sock_recv|
          sock_recv.bind(0)
          Socket.new(NETLINK_GENERIC) do |sock_snd|
            sock_snd.bind(0)
            sock_snd.sendmsg(data, 1, 0, 0, Addrinfo.new(sock_recv.addr))
            msg, = sock_recv.recvmsg
            expect(msg.data).to eq(data)
          end
        end
      end

      it 'accepts a Nl::Msg as first parameter' do
        Socket.new(NETLINK_GENERIC) do |sock_snd|
          msg = Nl::Msg.new(data: 'test', header: {type: NETLINK_GENERIC})
          sock_snd.bind(0)
          expect { sock_snd.sendmsg('test') }.to_not raise_error
        end
      end

      it 'raises if first argument is not a Nlmsg nor a String' do
        Socket.new(NETLINK_GENERIC) do |sock_snd|
          sock_snd.bind(0)
          expect { sock_snd.sendmsg(1_000_000) }.to raise_error(TypeError)
        end
      end
    end

    describe '#recvmsg' do
      it 'receives data from the socket', :sudo do
        data = 'Hello World!'
        Socket.new(NETLINK_GENERIC) do |sock_recv|
          sock_recv.bind(0)
          Socket.new(NETLINK_GENERIC) do |sock_snd|
            sock_snd.bind(0)
            sock_snd.sendmsg(data, 1, 0, 0, Addrinfo.new(sock_recv.addr))
            msg, = sock_recv.recvmsg
            expect(msg).to be_a(Nlmsg)
            expect(msg.data).to eq(data)
          end
        end
      end

      it 'returns address info', :sudo do
        data = 'Hello World!'
        Socket.new(NETLINK_GENERIC) do |sock_recv|
          sock_recv.bind(0)
          Socket.new(NETLINK_GENERIC) do |sock_snd|
            sock_snd.bind(0)
            sock_snd.sendmsg(data, 1, 0, 0, Addrinfo.new(sock_recv.addr))
            ary = sock_recv.recvmsg
            expect(ary).to be_a(Array)
            expect(ary.size).to eq(2)
            expect(ary[0].data).to eq(data)
            expect(ary[1]).to be_a(Addrinfo)
            expect(ary[1]).to eq(Addrinfo.new(sock_snd.addr))
          end
        end
      end

      it 'returns netlink message header', :sudo do
        data = 'Hello World!'
        Socket.new(NETLINK_GENERIC) do |sock_recv|
          sock_recv.bind(0)
          Socket.new(NETLINK_GENERIC) do |sock_snd|
            sock_snd.bind(0)
            sock_snd.sendmsg(data, 1, 0, 0, Addrinfo.new(sock_recv.addr))
            msg, = sock_recv.recvmsg
            expect(msg).to be_a(Nlmsg)
            expect(msg.header).to be_a(Nlmsg::Header)
            expect(msg.header.type).to eq(1)
            expect(msg.header.pid).to eq(sock_snd.addr[1])
          end
        end
      end

      it 'decodes a received ACK' do
        Socket.new(NETLINK_GENERIC) do |sock|
          sock.bind(0)
          sock.sendmsg('test', 1, NLM_F_ACK, 0, Addrinfo.new(['AF_NETLINK', 0, 0]))
          ack, = sock.recvmsg
          expect(ack).to be_a(Nl::MsgError)
          expect(ack.fields.error).to eq(0)
        end
      end
    end
  end
end