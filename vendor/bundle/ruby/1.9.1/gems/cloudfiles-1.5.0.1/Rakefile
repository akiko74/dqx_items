namespace :test do
  desc 'Check test coverage'
  task :coverage do
    rm_f "coverage"
    system("rcov -x '/Library/Ruby/Gems/1.8/gems/' --sort coverage #{File.join(File.dirname(__FILE__), 'test/*_test.rb')}")
    system("open #{File.join(File.dirname(__FILE__), 'coverage/index.html')}") if PLATFORM['darwin']
  end

  desc 'Remove coverage products'
  task :clobber_coverage do
    rm_r 'coverage' rescue nil
  end

end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end
