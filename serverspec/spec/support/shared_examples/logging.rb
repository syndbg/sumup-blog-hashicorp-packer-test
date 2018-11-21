# frozen_string_literal: true

require 'spec_helper'

RSpec.shared_examples 'logging' do
  describe file('/var/log/journal') do
    it { is_expected.to be_exists }
  end

  describe file('/etc/systemd/journald.conf') do
    it do
      expect(subject.content).to match_golden_file('spec/goldenfiles/logging/journald.conf')
    end
  end

  describe service('systemd-journald') do
    it { is_expected.to be_enabled }
  end
end
