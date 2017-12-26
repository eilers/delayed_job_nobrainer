# DelayedJob NoBrainer Backend

This backend runs DelayedJob on top of RethinkDB (https://rethinkdb.com) by using NoBrainer (http://nobrainer.io) as ORM layer.

## Status
Please note that the tests are currently not passing. They are leftovers from the original delayed_job_active_record backend, which I used as template. I will fix them as soon as possible!
But the backend works in my current testing environment and will be used for the production version of my project until end of January 2018. Thus, you can expect them as stable.
If you find any issues: Please file a bug report.

## Installation

Add the gem to your Gemfile:

    gem 'delayed_job_nobrainer'

Run `bundle install`.

That's it. Use [delayed_job as normal](http://github.com/collectiveidea/delayed_job).

## Rails >= 4.2
DelayedJob supports ActiveJobs. In order to use this backend, you only have to add the following line into your 'configuration/application.rb':

    config.active_job.queue_adapter = :delayed_job

