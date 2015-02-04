require 'rubygems'
require 'bundler/setup'
require 'net/http'
require 'uri'
require 'logger'

require 'failover/version'
require 'failover/health_check'
require 'failover/failure'
require 'failover/replacement'
require 'failover/restoration'
require 'failover/watcher'

module Failover
end
