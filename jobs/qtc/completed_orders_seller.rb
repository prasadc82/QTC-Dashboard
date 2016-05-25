SCHEDULER.every '60s', first_in: 0, allow_overlapping: false do |job|
  key        = "_BoeKszl0ZdkJKXdlAWWHccqEyXMuW-S"
  account_id = "131445"
  nrql       = "SELECT uniqueCount(`orderInfo.orderId`) as 'No of Completed Orders' FROM QTCGatewayEvent where method = 'post' AND path = '/payments' AND  `account.dataSource` = 'Seller' AND message = 'Approved' AND appName = 'QTC Gateway' and `account.email` not like '%@gmail.com' and `account.email` not like '%@yahoo.com' FACET platform SINCE 1 week ago"
  json       = NewRelic::Insights::Query.new(key, account_id).call(nrql)
  facets     = json.fetch(:facets).map { |hash| { label: hash[:name], value: hash[:results].first[:uniqueCount]} }
  
  send_event('completed_orders_seller_flow', { items: facets })
end
