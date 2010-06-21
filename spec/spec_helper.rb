$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'config_file_loader'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  ConfigFileLoader.base = File.join(File.dirname(__FILE__),'config/')
end
