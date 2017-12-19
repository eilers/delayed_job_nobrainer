require "nobrainer"
require "delayed_job"

require "delayed/backend/nobrainer"
Delayed::Worker.backend = Delayed::Backend::NoBrainer::Job
