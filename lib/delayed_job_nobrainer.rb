require "nobrainer"
require "delayed_job"

require "delayed/backend/nobrainer"
require "rake_tasks"
Delayed::Worker.backend = Delayed::Backend::NoBrainer::Job
