


ActiveSupport::Notifications.subscribe /process_action.action_controller/ do |name, start, ending, transaction_id, payload| 
    format = payload[:format] || "all" 
    format = "all" if format == "*/*" 
    key = "controllers.#{payload[:controller]}.#{payload[:action]}.#{format}." 
    StatsD.measure(key+"db_runtime", payload[:db_runtime] || 0, sample_rate: 0.1)
    StatsD.measure(key+"view_runtime", payload[:view_runtime]  || 0, sample_rate: 0.1)
    StatsD.measure(key+"total_runtime", 1000.0 * (ending - start), sample_rate: 0.1) # time in ms
  end

Submission.extend StatsD::Instrument
Submission.statsd_count :evaluate_delayed, 'submission.queued'