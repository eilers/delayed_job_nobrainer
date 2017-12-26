# DelayedJob NoBrainer Backend

This backend runs DelayedJob on top of RethinkDB (https://rethinkdb.com) by using NoBrainer (http://nobrainer.io) as ORM layer.

## Installation

Add the gem to your Gemfile:

    gem 'delayed_job_nobrainer'

Run `bundle install`.

That's it. Use [delayed_job as normal](http://github.com/collectiveidea/delayed_job).

## Rails >= 4.2
DelayedJob supports ActiveJobs. In order to use this backend, you only have to add the following line into your 'configuration/application.rb':

    config.active_job.queue_adapter = :delayed_job

