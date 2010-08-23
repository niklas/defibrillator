require 'factory_girl'

Dir[ File.dirname(__FILE__) + '/../../spec/factories/*' ].each {|f| require f.sub(/\.rb$/,'') }
