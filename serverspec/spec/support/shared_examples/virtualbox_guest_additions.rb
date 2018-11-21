# frozen_string_literal: true

require 'spec_helper'

RSpec.shared_examples 'virtualbox guest additions' do
  context 'when running in virtualbox guest', is_virtualbox: true do
    context 'with dependencies' do
      describe package('build-essential') do
        it { is_expected.to be_installed }
      end

      describe package('dkms') do
        it { is_expected.to be_installed }
      end

      describe 'package "linux-headers"' do
        it do
          kernel_version = command('uname -r').stdout.strip
          pkg = package("linux-headers-#{kernel_version}")
          expect(pkg).to be_installed
        end
      end
    end

    describe file('/root/.vbox_version') do
      it { is_expected.to exist }
    end

    describe kernel_module('vboxsf') do
      it { is_expected.to be_loaded }
    end
  end

  context 'when not running in virtualbox guest', is_not_virtualbox: true do
    describe kernel_module('vboxsf') do
      it { is_expected.not_to be_loaded }
    end
  end
end
