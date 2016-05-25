SCHEDULER.every '1h', first_in: 0, allow_overlapping: false do |job|
  key        = "_BoeKszl0ZdkJKXdlAWWHccqEyXMuW-S"
  account_id = "131445"
  nrql       = "SELECT count(*) as 'Saml Interaction Failures' FROM `Saml Interaction`, PageView WHERE appName = 'QTC Gateway' FACET isValid TIMESERIES 24 hour SINCE 1 month ago"
  json       = NewRelic::Insights::Query.new(key, account_id).call(nrql)
  points = []

  # average of begin-time and end-time
  json[:facets].each do |facet|
    points << facet[:timeSeries].map { |record| { :x => ((record[:beginTimeSeconds] + record[:endTimeSeconds]) / 2), :y => record[:results][0][:count]} }
  end

  # there should be equal number of data points for both valid and in-valid
  # facets, if not fill-up with zeros.
  if points[1].length == 0
    points[1] = points[0].map do |hash|
      return { x: hash[:x], y: 0 }
    end
  end

  send_event('logins', points_1: points[0], points_2: points[1])
end
