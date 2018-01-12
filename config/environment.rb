# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# Initialise the statsD backend
StatsD.backend = StatsD::Instrument::Backends::UDPBackend.new("localhost:8125", :statsd)
StatsD.prefix  = "dodona"