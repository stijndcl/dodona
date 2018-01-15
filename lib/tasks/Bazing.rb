require 'delayed_job'

class Bazing < Delayed::Plugin

  callbacks do |lifecycle|
    lifecycle.around(:invoke_job) do |job, *args, &block|
      Submission.extend StatsD::Instrument
      Submission.statsd_count :save_result, 'submission.handled'
      block.call(job, *args)
    end
  end

end