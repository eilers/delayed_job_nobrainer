Gem::Specification.new do |spec|
  spec.add_dependency "nobrainer", [">= 0.32"]
  spec.add_dependency "delayed_job",  [">= 3.0", "< 5"]
  spec.authors        = ["Stefan Eilers"]
  spec.description    = "NoBrainer backend for Delayed::Job, based on delayed_job_active_record"
  spec.email          = ["se@intelligentmobiles.com"]
  spec.files          = %w(CONTRIBUTING.md LICENSE.md README.md delayed_job_nobrainer.gemspec) + Dir["lib/**/*.rb"]
  spec.homepage       = "https://github.com/eilers/delayed_job_nobrainer"
  spec.licenses       = ["MIT"]
  spec.name           = "delayed_job_nobrainer"
  spec.require_paths  = ["lib"]
  spec.summary        = "NoBrainer backend for DelayedJob"
  spec.version        = "0.1.5"
end
