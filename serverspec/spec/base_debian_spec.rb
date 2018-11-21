# frozen_string_literal: true

require 'spec_helper'

describe 'base debian image' do
  include_examples 'virtualbox guest additions'
  include_examples 'qemu guest agent'
  include_examples 'SSH'
  include_examples 'disable lvmetad'
  include_examples 'logging'
end
