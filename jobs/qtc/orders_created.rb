SCHEDULER.every '300s', first_in: 0, allow_overlapping: false do |job|
  key        = "_BoeKszl0ZdkJKXdlAWWHccqEyXMuW-S"
  account_id = "131445"
  nrql       = "SELECT uniqueCount(opportunityId) FROM QTCGatewayEvent where method = 'post' AND path = '/orders' AND appName = 'QTC Gateway' and createdBy not in ('imctest1@reachlocal.com', 'canada.imc1@reachlocal.com', 'qtc.seller1@reachlocal.com') SINCE 1 week ago"
  json       = NewRelic::Insights::Query.new(key, account_id).call(nrql)
  count      = json.fetch(:results).first.fetch(:uniqueCount)
  
  send_event('orders_created', { value: count })
end
