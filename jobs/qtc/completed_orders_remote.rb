SCHEDULER.every '60s', first_in: 0, allow_overlapping: false do |job|
  key        = "_BoeKszl0ZdkJKXdlAWWHccqEyXMuW-S"
  account_id = "131445"
  nrql       = "SELECT uniquecount(orderId) as 'No of Completed Orders' FROM QTCGatewayEvent where method = 'post' AND path = '/public/payments' AND `account.dataSource` = 'Remote' AND appName = 'QTC Gateway' and `account.email` not like '%@gmail.com' and `account.email` not like '%@yahoo.com' FACET `account.country` SINCE 1 week ago"
  json       = NewRelic::Insights::Query.new(key, account_id).call(nrql)
  facets     = json.fetch(:facets).map { |hash| { label: hash[:name], value: hash[:results].first[:uniqueCount]} }
  
  send_event('completed_orders_remote_flow', { items: facets })
end
