# frozen_string_literal: true

require 'spec_helper'

RSpec.shared_examples 'qemu guest agent' do
  context 'when running in qemu guest', is_qemu: true do
    describe package('qemu-guest-agent') do
      it { is_expected.to be_installed }
    end
  end

  context 'when not running in qemu guest', is_not_qemu: true do
    describe package('qemu-guest-agent') do
      it { is_expected.not_to be_installed }
    end
  end
end
