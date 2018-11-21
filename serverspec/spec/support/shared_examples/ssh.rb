# frozen_string_literal: true

require 'spec_helper'

RSpec.shared_examples 'SSH' do
  describe package('wget') do
    it { is_expected.to be_installed }
  end

  describe 'contents of authorized_keys' do
    it do
      guest_file = file('/root/.ssh/authorized_keys').content

      expect(guest_file).to match_golden_file('spec/goldenfiles/ssh/authorized_keys')
    end
  end
end
