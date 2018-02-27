require "nobrainer"

module Delayed
    module Backend
        module NoBrainer
            # A job object that is persisted to the database.
            # Contains the work object as a YAML field.
            class Job
                include ::NoBrainer::Document
                include ::NoBrainer::Document::Timestamps
                include Delayed::Backend::Base

                cattr_accessor :default_queue

                self.default_queue = "default"

                field :priority,    :type => Integer,   :index => true
                field :attempts,    :type => Integer
                field :handler,     :type => Text
                field :last_error,  :type => String
                field :run_at,      :type => Time,      :index => true
                field :locked_at,   :type => Time
                field :locked_by,   :type => String,    :index => true
                field :failed_at,   :type => Time
                field :queue,       :type => String,    :index => true

                before_create do |o|
                    o.attempts   = 0
                    o.priority ||= 0
                    o.queue    ||= self.class.default_queue
                    o.run_at   ||= Time.now
                end

                # Get the current time (GMT or local depending on DB)
                # Note: This does not ping the DB to get the time, so all your clients
                # must have syncronized clocks.
                def self.db_time_now
                    if Time.zone
                        Time.zone.now
                    else
                        Time.now
                    end
                end

                def self.clear_locks!(worker_name)
                    where(locked_by: worker_name).update_all(locked_by: nil, locked_at: nil)
                end

                def self.reserve(worker, max_run_time = Worker.max_run_time)
                    # Taken from Active Record
                    # where("(run_at <= ? AND (locked_at IS NULL OR locked_at < ?) OR locked_by = ?) AND failed_at IS NULL", db_time_now, db_time_now - max_run_time, worker_name)
                    # "priority >= ?", Worker.min_priority if Worker.min_priority
                    # "priority <= ?", Worker.max_priority) if Worker.max_priority
                    # where(queue: Worker.queues) if Worker.queues.any?
                    # order("priority ASC, run_at ASC") }

                    filter_hash = { :failed_at.defined => false, :run_at.le => db_time_now,
                                    :or => [{:locked_at.defined => false},
                                            {:locked_at.lt => db_time_now - max_run_time},
                                            :locked_by => worker.name] }
                    filter_hash = filter_hash.merge({:priority.ge => Worker.min_priority}) if Worker.min_priority
                    filter_hash = filter_hash.merge({:priority.le => Worker.max_priority}) if Worker.max_priority
                    filter_hash = filter_hash.merge({:queue.in => Worker.queues}) if Worker.queues.any?

                    job = where(filter_hash).order_by(:priority => :asc).order_by(:created_at => :asc).first
                    job.update(locked_at: Time.now, locked_by: worker.name) unless job.nil?
                    job
                end

                def error
                    unless instance_variable_defined?(:@error)
                        if last_error
                            backtrace = last_error.split("\n")
                            message = backtrace.shift
                            @error = Exception.new(message)
                            @error.set_backtrace(backtrace)
                        else
                            @error = nil
                        end
                    end
                    @error
                end

                def error=(error)
                    @error = error
                    self.last_error = "#{error.message}\n#{error.backtrace.join("\n")}"[0..250].gsub(/\s\w+\s*$/,'...') if self.respond_to?(:last_error=)
                end

            end
        end
    end
end
