SCHEDULER.every '300s', first_in: 0, allow_overlapping: false do |job|
  key        = "_BoeKszl0ZdkJKXdlAWWHccqEyXMuW-S"
  account_id = "131445"
  nrql       = "SELECT uniqueCount(`orderInfo.orderId`) as 'No of Completed Orders' FROM QTCGatewayEvent where method = 'post' AND ( path = '/payments' OR path = '/public/payments' ) AND message = 'Approved' AND appName = 'QTC Gateway' and `account.email` not like '%@gmail.com' and `account.email` not like '%@yahoo.com' SINCE 1 week ago"
  json       = NewRelic::Insights::Query.new(key, account_id).call(nrql)
  count      = json.fetch(:results).first.fetch(:uniqueCount)
  
  send_event('orders_completed', { value: count })
end
