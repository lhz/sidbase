# -*- coding: utf-8 -*-
class ApiLogger < ::Logger

  # Prefix added to all log messages
  attr_accessor :prefix

  # add severity, timestamp and (optional) thread name
  def format_message(severity, timestamp, progname, msg)
    # $stderr.puts "format_message: #{msg}"
    sprintf "%s,%03d %7s: %s%s\n",
    timestamp.strftime("%Y-%m-%d %H:%M:%S"),
    (timestamp.usec / 1000).to_s,
    severity,
    prefix.nil? ? "" : "#{prefix} ",
    msg
  end

  # Debug time spent in the given block
  def debug_time(msg, &block)
    t0 = Time.now
    value = block.call
    debug "TIME: #{msg} #{sprintf "%.6f", (Time.now - t0)} sec"
    value
  end

end
