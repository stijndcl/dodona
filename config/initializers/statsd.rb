StatsD.backend = StatsD::Instrument::Backends::UDPBackend.new("localhost:8125", :statsd)
StatsD.prefix  = "dodona"


ActiveSupport::Notifications.subscribe /process_action.action_controller/ do |name, start, ending, transaction_id, payload|
    format = payload[:format] || "all" 
    format = "all" if format == "*/*" 
    key = "controllers.#{payload[:controller]}.#{payload[:action]}.#{format}." 
    StatsD.measure(key+"db_runtime", payload[:db_runtime], sample_rate: 1.0)
    StatsD.measure(key+"view_runtime", payload[:view_runtime], sample_rate: 1.0)
    StatsD.measure(key+"total_runtime", 1000.0 * (ending - start), sample_rate: 1.0) # time in ms
  end


Submission.extend StatsD::Instrument
Submission.statsd_count :save, 'submissions.new'

