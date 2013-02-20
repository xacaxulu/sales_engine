require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.pattern = "test/*_test.rb"
end

task :gem do
  sh "gem build sales_engine.gemspec"
end

task :harness => :gem do
  harness_path = File.expand_path("../../sales_engine_spec_harness", __FILE__)

  unless File.exist?(harness_path)
    sh "git clone https://github.com/JumpstartLab/sales_engine_spec_harness.git '#{harness_path}'"
  end

  Dir.chdir(harness_path) do
    sh "git pull"
    sh "bundle exec rspec spec"
  end
end

namespace :sanitation do
  desc "Check line lengths & whitespace with Cane"
  task :lines do
    puts ""
    puts "== using cane to check line length =="
    system("cane --no-abc --style-glob 'lib/**/*.rb' --no-doc")
    puts "== done checking line length =="
    puts ""
  end

  desc "Check method length with Reek"
  task :methods do
    puts ""
    puts "== using reek to check method length =="
    system("reek -n lib/**/*.rb 2>&1 | grep -v ' 0 warnings'")
    puts "== done checking method length =="
    puts ""
  end

  desc "Check both line length and method length"
  task :all => [:lines, :methods]
end
