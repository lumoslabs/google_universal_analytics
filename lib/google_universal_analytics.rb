require "google_universal_analytics/version"

module GoogleUniversalAnalytics

  class InvalidOptionsError < StandardError
  end

  def google_universal_analytics_init(options = {})
    unless options[:tracker]
      raise InvalidOptionsError.new("Missing tracker number")
    end

    "<script>\n" +
    "(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){\n" +
    "(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),\n" +
    "m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)\n" +
    "})(window,document,'script','//www.google-analytics.com/analytics.js','ga');\n" +

    "ga('create', '#{options[:tracker]}'#{options[:domain] ? ", { cookieDomain: '#{options[:domain]}' }" : nil});\n" +

    "#{custom_vars_jscript(options[:custom_vars])}\n" +
    "#{track_events_jscript(options[:events])}\n" +
    "ga('send', 'pageview');\n" +

    "</script>\n"
  end

  def custom_vars_jscript(custom_vars = [])
    return nil unless custom_vars
    custom_vars.map { |cv| custom_var_jscript(cv) }.join("\n")
  end

  def track_events_jscript(events = [])
    return nil unless events
    events.map { |event| track_event_jscript(event) }.join("\n")
  end

  def custom_var_jscript(custom_var)
    "ga('set', 'dimension#{custom_var[:index]}', '#{custom_var[:value]}');"
  end

  def track_event_jscript(event)
    "ga('send', 'event', '#{event[:category]}', '#{event[:action]}', '#{event[:label]}', '#{event[:value]}');"
  end
end
