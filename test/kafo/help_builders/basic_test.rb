require 'test_helper'

module Kafo
  module HelpBuilders
    describe Basic do
      let(:params) do
        [
            Params::String.new(OpenStruct.new(:name => 'puppet'), 'version').tap do |p|
              p.doc    = "version parameter"
              p.groups = []
            end,
            Params::Boolean.new(OpenStruct.new(:name => 'puppet'), 'server').tap do |p|
              p.doc    = "enable puppetmaster server"
              p.groups = ["Advanced parameters:"]
            end,
            Params::Integer.new(OpenStruct.new(:name => 'puppet'), 'port').tap do |p|
              p.doc    = "puppetmaster port"
              p.groups = ["Advanced parameters:"]
            end,
            Params::Integer.new(OpenStruct.new(:name => 'apache'), 'port').tap do |p|
              p.doc    = "apache port"
              p.groups = []
            end,
        ]
      end

      let(:clamp_definitions) do
        [
            OpenStruct.new(:help => ['--puppet-version', 'version parameter']),
            OpenStruct.new(:help => ['--reset-puppet-version', 'Reset version to the default value']),
            OpenStruct.new(:help => ['--puppet-server', 'enable puppetmaster server']),
            OpenStruct.new(:help => ['--reset-puppet-server', 'Reset server to the default value']),
            OpenStruct.new(:help => ['--puppet-port', 'puppetmaster port']),
            OpenStruct.new(:help => ['--reset-puppet-port', 'Reset port to the default value']),
            OpenStruct.new(:help => ['--no-colors', 'app wide argument, not a parameter']),
            OpenStruct.new(:help => ['--apache-port', 'apache module parameter']),
            OpenStruct.new(:help => ['--reset-apache-port', 'Reset port to the default value']),
        ]
      end

      let(:stdout) { StringIO.new }
      let(:builder) { HelpBuilders::Basic.new(params) }

      before { builder.instance_variable_set '@out', stdout }

      # note that these test do not preserve any order
      describe "#add_list" do
        before { builder.add_list('Options', clamp_definitions) }
        let(:output) { stdout.rewind; stdout.read }
        specify { output.must_include 'Options' }
        specify { output.must_include '= Generic:' }
        specify { output.must_include '--no-colors' }
        specify { output.must_include 'app wide argument, not a parameter' }
        specify { output.must_include '= Module puppet:' }
        specify { output.must_include '--puppet-version' }
        specify { output.must_include 'version parameter' }
        specify { output.wont_include '--reset-puppet-version' }
        specify { output.wont_include 'reset puppet-version' }
        specify { output.wont_include '--puppet-server' }
        specify { output.wont_include 'enable puppetmaster server' }
        specify { output.wont_include '--reset-puppet-server' }
        specify { output.wont_include 'reset puppet-server' }
        specify { output.wont_include '--puppet-port' }
        specify { output.wont_include 'puppetmaster port' }
        specify { output.wont_include '--reset-puppet-port' }
        specify { output.wont_include 'reset puppet-port' }
        specify { output.wont_include 'Basic' }
        specify { output.wont_include 'Advanced' }
        specify { output.must_match /Generic.*Module apache.*Module puppet/m}
      end
    end
  end
end
