# frozen_string_literal: true

require 'serverspec'
require 'net/ssh'
require 'rspec-golden-files'

Dir[
    File.expand_path(
      File.join(
        File.dirname(__FILE__),
        'support', '**', '*.rb'
      )
    )
].each { |f| require f }

set :backend, :ssh
set :sudo_password, ENV['SUDO_PASSWORD']
set :paranoid, false

options = Net::SSH::Config.for(ENV['TARGET_HOST'])

options[:user] = ENV['TARGET_USER'] if ENV['TARGET_USER']
options[:user] ||= Etc.getlogin
options[:port] = ENV['TARGET_PORT'] if ENV['TARGET_PORT']
options[:password] = ENV['TARGET_PASSWORD'] if ENV['TARGET_PASSWORD']
options[:auth_methods] = %w[password publickey]

set :host,        options[:host_name] || ENV['TARGET_HOST']
set :ssh_options, options

# NOTE: Disable sudo since it's not used.
# Tests are assumed to be run as root.
set :disable_sudo, true

if !ENV['BUILDER_TYPE'] || ENV['BUILDER_TYPE'].empty?
  raise 'no environment variable `BUILDER_TYPE` provided'
end

is_virtualbox = ENV['BUILDER_TYPE']&.start_with?('virtualbox')
is_qemu = ENV['BUILDER_TYPE'] == 'qemu'

RSpec.configure do |config|
  # NOTE: Disable `should` syntax.
  # Expect is the only absolute.
  # ref: http://www.betterspecs.org/#should
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.include RSpec::GoldenFiles
  config.filter_run_excluding is_virtualbox: !is_virtualbox
  config.filter_run_excluding is_not_virtualbox: is_virtualbox
  config.filter_run_excluding is_qemu: !is_qemu
  config.filter_run_excluding is_not_qemu: is_qemu
end

# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C'

# NOTE: Set PATH since
# set :path, '/sbin:/usr/local/sbin:$PATH'
