# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'blobby-gcs'
  spec.version       = 0.1
  spec.authors       = ['Jerome Paul']
  spec.email         = ['jerome.paul@greensync.com.au']

  spec.summary       = 'Store BLOBs in Google Cloud Storage'
  spec.homepage      = 'https://github.com/greensync/blobby-gcs'
  spec.license       = 'MIT'

  spec.files += Dir['lib/**/*']
  spec.files += Dir['LICENSE.txt']
  spec.files += Dir['blobby-gcs.gemspec']
  spec.files += Dir['Gemfile']
  spec.files += Dir['Gemfile.lock']
  spec.files += Dir['README.md']

  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'bundler-audit', '~> 0.6.1'
  spec.add_development_dependency 'pry-byebug', '~> 3.7'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.78.0'

  spec.add_runtime_dependency('blobby', '~> 1.1.0')
  spec.add_runtime_dependency('google-cloud-storage', '~> 1.25')
end
