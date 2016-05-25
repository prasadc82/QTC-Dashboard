SCHEDULER.every '60s', first_in: 0, allow_overlapping: false do |job|
  key        = "_BoeKszl0ZdkJKXdlAWWHccqEyXMuW-S"
  account_id = "131445"
  nrql       = "SELECT uniqueCount(session) FROM PageView WHERE appName = 'qtc-client' SINCE 5 minutes AGO"
  json       = NewRelic::Insights::Query.new(key, account_id).call(nrql)
  count      = json.fetch(:results).first.fetch(:uniqueCount)
  
  send_event('sessions', { current: count })
end
