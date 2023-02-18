# frozen_string_literal: true

module Netlink
  module Nl
    RSpec.describe Base do
      it 'has an empty header' do
        expect(Base.header).to eq({})
      end

      it 'has empty fields' do
        expect(Base.fields).to eq({})
      end

      it 'has empty attributes' do
        expect(Base.attributes).to eq({})
      end
    end
  end
end
