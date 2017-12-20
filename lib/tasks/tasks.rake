namespace :jobs do
    desc "Exit with error status if any jobs older than max_age seconds haven't been attempted yet."
    task :nobrainer_check, [:max_age] => :environment do |_, args|
        args.with_defaults(:max_age => 300)

        unprocessed_jobs = Delayed::Job.where(attempts: 0, :created_at.lt => Time.now - args[:max_age].to_i).count

        if unprocessed_jobs > 0
            raise "#{unprocessed_jobs} jobs older than #{args[:max_age]} seconds have not been processed yet"
        end
    end

    desc "Restart jobs that failed."
    task :restart  => :environment_options do
        Delayed::Job.where(:attempts.gt => 0).each { |j| j.attempts = 0; j.save }
    end
end
