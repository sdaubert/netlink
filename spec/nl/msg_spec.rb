# frozen_string_literal: true

module Netlink
  module Nl
    RSpec.describe Msg do
      describe '#to_s' do
        let (:result_flags) { Constants::NLM_F_REQUEST | Constants::NLM_F_ACK }
        it 'encodes Msg header' do
          msg = Msg.new(type: 1, flags: 0, seq: 2, pid: 3)
          expect(msg.to_s).to eq([16, 1, 0, 2, 3].pack('LSSLL'))
        end

        it 'encodes flags when given as an integer' do
          msg = Msg.new(flags: Constants::NLM_F_REQUEST | Constants::NLM_F_ACK)
          expect(msg.to_s).to eq([16, 0, result_flags, 0, 0].pack('LSSLL'))
        end

        it 'encodes flags when given as an array of symbols' do
          msg = Msg.new(flags: %i[request ack])
          expect(msg.to_s).to eq([16, 0, result_flags, 0, 0].pack('LSSLL'))
        end
      end
    end
  end
end
