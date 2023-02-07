# frozen_string_literal: true

RSpec.describe Netlink do
  it "has a version number" do
    expect(Netlink::VERSION).not_to be nil
  end
end
