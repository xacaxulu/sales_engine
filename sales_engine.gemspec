# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'bundler/version'
 
Gem::Specification.new do |s|
  s.name = "sales_engine"
  s.version = "1.0.0"
  s.authors = ["Paul Blackwell", "James Denman"]
  s.email = ["pnblackwell@gmail.com", "denmanjd@gmail.com"]
  s.homepage = "https://github.com/jdendroid/sales_engine"
  s.summary = "Data reporting tool that manipulates and reports on merchant transactional data"
  s.description = "Data reporting tool that manipulates and reports on merchant transactional data"
 
  s.required_rubygems_version = ">= 1.3.6"
 
  s.add_development_dependency "minitest"
 
  s.files = Dir.glob("{bin,lib,data}/**/*")
  s.require_path = 'lib'
end
