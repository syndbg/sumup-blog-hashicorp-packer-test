# frozen_string_literal: true

require 'spec_helper'

RSpec.shared_examples 'disable lvmetad' do
  describe '/etc/lvm/lvm.conf' do
    it do
      file_contents = file('/etc/lvm/lvm.conf').content
      expect(file_contents).not_to contain('use_lvmetad = 1')
      expect(file_contents).to contain('use_lvmetad = 0')
    end
  end
end
