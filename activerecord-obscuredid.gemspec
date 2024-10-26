# frozen_string_literal: true

require_relative 'lib/activerecord-obscuredid/version'

Gem::Specification.new do |spec|
  spec.name = 'activerecord-obscuredid'
  spec.version = ActiveRecord::ObscuredId::VERSION
  spec.authors = ['darthrighteous']
  spec.email = ['ja.ogunniyi@gmail.com']

  spec.summary = 'A gem to generate obscured IDs for ActiveRecord models.'
  spec.description = 'This gem provides functionality to encode and decode model IDs into Base32-obscured strings,
    making it easy to obscure model IDs when exposing them in URLs or emails.'

  spec.homepage = 'https://github.com/darthrighteous/activerecord-obscuredid'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/darthrighteous/activerecord-obscuredid'
  spec.metadata['changelog_uri'] = 'https://github.com/darthrighteous/activerecord-obscuredid/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ .git .github .idea .ruby-lsp Gemfile Gemfile.lock])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 5.0'
end
