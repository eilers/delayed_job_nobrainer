require "helper"
require "delayed/backend/nobrainer"

describe Delayed::Backend::NoBrainer::Job do
    it_behaves_like "a delayed_job backend"

    describe "reserve_with_scope" do
        let(:worker) { double(name: "worker01", read_ahead: 1) }
        let(:scope)  { double(limit: limit, where: double(update_all: nil)) }
        let(:limit)  { double(job: job, update_all: nil) }
        let(:job)    { double(id: "abc") }

        before do
        end


        describe "enqueue" do
            it "allows enqueue hook to modify job at DB level" do
                byebug
                later = described_class.db_time_now + 20.minutes
                job = Delayed::Backend::NoBrainer::Job.enqueue payload_object: EnqueueJobMod.new
                expect(Delayed::Backend::NoBrainer::Job.find(job.id).run_at).to be_within(1).of(later)
            end
        end

    end
end
