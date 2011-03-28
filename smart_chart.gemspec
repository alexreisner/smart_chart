# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "smart_chart"
  s.version     = File.read(File.join(File.dirname(__FILE__), 'VERSION'))
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Alex Reisner"]
  s.email       = ["alex@alexreisner.com"]
  s.homepage    = "http://www.github.com/alexreisner/smart_chart"
  s.date        = Date.today.to_s
  s.summary     = "Easily create charts and graphs for the web (using Google Charts)."
  s.description = "Easily create charts and graphs for the web (using Google Charts)."
  s.files       = `git ls-files`.split("\n") - %w[smart_chart.gemspec Gemfile]
  s.require_paths = ["lib"]
end
