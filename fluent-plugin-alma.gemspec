# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-alma"
  spec.version       = '0.0.1'
  spec.authors       = ["Teppei Fukuda"]
  spec.email         = ["put.a.feud.pike011235@gmail.com"]

  spec.summary       = %q{ Fluentd plugin for Alma.}
  spec.description   = %q{ output events to Alma for managing alert.}
  spec.homepage      = "http://github.com/knqyf263/fluent-plugin-alma"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = " Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "fluentd"
  spec.add_runtime_dependency "alma-client"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit"
end
