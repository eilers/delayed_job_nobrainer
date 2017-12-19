require "simplecov"
require "coveralls"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
                                                                 SimpleCov::Formatter::HTMLFormatter,
                                                                 Coveralls::SimpleCov::Formatter
])

SimpleCov.start do
    add_filter "/spec/"
    minimum_coverage(73.33)
end

require "logger"
require "rspec"

begin
    require "protected_attributes"
rescue LoadError # rubocop:disable HandleExceptions
end
require "delayed_job_nobrainer"
require "delayed/backend/shared_spec"

Delayed::Worker.logger = Logger.new("/tmp/dj.log")
ENV["RAILS_ENV"] = "test"

# Purely useful for test cases...
class Story
    include ::NoBrainer::Document
    include ::NoBrainer::Document::Timestamps
    #    self.primary_key = :story_id
    def tell
        text
    end

    def whatever(n, _)
        tell * n
    end
    default_scope { where(scoped: true) }

    handle_asynchronously :whatever
end

# Add this directory so the ActiveSupport autoloading works
ActiveSupport::Dependencies.autoload_paths << File.dirname(__FILE__)
