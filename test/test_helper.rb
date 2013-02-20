require 'simplecov'
SimpleCov.start
require 'rubygems'
gem 'minitest'
require 'minitest/autorun'
require './lib/sales_engine'

Dir.glob('./test/*.rb').each do |f|
  require f
end

SalesEngine.startup
