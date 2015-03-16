# -*- encoding: utf-8 -*-
VERSION = "0.0.1"

Gem::Specification.new do |spec|
  spec.name          = "motion-concierge"
  spec.version       = VERSION
  spec.authors       = ["Mark Rickert"]
  spec.email         = ["mjar81@gmail.com"]
  spec.description   = "motion-concierge is your personal data concierge!. Just provide a file name, and network url, and set up some basic rules regarding when to download the data and the concierge will automatically fetch your data for you from the web!"
  spec.summary       = "motion-concierge is your personal data concierge!"
  spec.homepage      = "https://github.com/OTGApps/motion-concierge"
  spec.license       = "MIT"

  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "motion-cocoapods", "~> 1.7"
  spec.add_dependency "afmotion", "~> 2.5"
  spec.add_development_dependency "rake", "~> 10.0", "> 10.0"
  spec.add_development_dependency "motion_print", "~> 0", "> 0"
end
