require 'rubygems'
require 'bundler/setup'

require 'config-file-loader'

RSpec.configure do |config|
  ConfigFileLoader.base = File.join(File.dirname(__FILE__),'config/')
end
