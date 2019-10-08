
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "nlu_tools/version"

Gem::Specification.new do |spec|
  spec.name          = "nlu_tools"
  spec.version       = NluTools::VERSION
  spec.authors       = ["Girish Nair"]
  spec.email         = ["getgirish@gmail.com"]

  spec.summary       = %q{NLU Tools in Ruby}
  spec.description   = %q{A Toolset for NLU evaluation}
  spec.homepage      = "https://rubygems.org/gems/nlu_tools"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "http://rubygems.org"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/technopreneurG/nlu_tools_ruby"
    spec.metadata["changelog_uri"] = "https://github.com/technopreneurG/nlu_tools_ruby/blob/master/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'yard', '~> 0.9.20'
  spec.add_development_dependency 'rubocop', '~> 0.75.0'

  spec.add_dependency('nlu_adapter', '~> 0.1.6')
end
