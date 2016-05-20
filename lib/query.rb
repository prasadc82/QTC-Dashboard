require 'net/http'
require 'uri'
require 'json'

module NewRelic
  module Insights
    class Query
      attr_reader :key, :account_id

      def initialize(key, account_id)
        @key        = key
        @account_id = account_id
      end

      def call(nrql)
        get uri(URI.encode_www_form(nrql: nrql))
      end

      private

      def uri(query)
        URI::HTTPS.build(host: host, path: path, query: query)
      end

      def get(uri)
        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |client|
          request                = Net::HTTP::Get.new(uri)
          request["Accept"]      = "application/json"
          request["X-Query-Key"] = key
          response               = client.request(request)

          return JSON.parse(response.body, symbolize_names: true)
        end
      end

      def host
        "insights-api.newrelic.com"
      end

      def path
        "/v1/accounts/#{account_id}/query"
      end
    end
  end
end
