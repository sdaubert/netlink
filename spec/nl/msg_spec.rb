# frozen_string_literal: true

module Netlink
  module Nl
    RSpec.describe Msg do
      describe '#encode' do
        let (:result_flags) { Constants::NLM_F_REQUEST | Constants::NLM_F_ACK }
        it 'encodes Msg header' do
          msg = Msg.new(header: { type: 1, flags: 0, seq: 2, pid: 3 })
          expect(msg.encode).to eq([16, 1, 0, 2, 3].pack('LSSLL'))
        end

        it 'encodes flags when given as an integer' do
          msg = Msg.new(header: { flags: Constants::NLM_F_REQUEST | Constants::NLM_F_ACK })
          expect(msg.encode).to eq([16, 0, result_flags, 0, 0].pack('LSSLL'))
        end

        it 'encodes flags when given as an array of integers' do
          msg = Msg.new(header: { flags: [Constants::NLM_F_REQUEST, Constants::NLM_F_ACK] })
          expect(msg.encode).to eq([16, 0, result_flags, 0, 0].pack('LSSLL'))
        end

        it 'encodes flags when given as an array of symbols' do
          msg = Msg.new(header: { flags: %i[request ack] })
          expect(msg.encode).to eq([16, 0, result_flags, 0, 0].pack('LSSLL'))
        end
      end
    end
  end
end
