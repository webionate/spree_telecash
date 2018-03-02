module Spree
  class Gateway::Telecash < Gateway
    preference :payment_methods, :string, default: "v m a"
    preference :url, :string, default: "https://test.ipg-online.com/connect/gateway/processing"
    preference :wsdl, :string, default: "https://test.ipg-online.com/ipgapi/services/order.wsdl"

    preference :store, :string, default: ""
    preference :secret, :string, default: ""

    preference :api_user, :string, default: ""
    preference :api_password, :string, default: ""
    preference :ssl_certificate, :text, default: ""
    preference :ssl_certificate_key, :text, default: ""
    preference :ssl_certificate_key_password, :string, default: ""

    def method_type
      "telecash"
    end

    def payment_source_class
      ::Telecash::ConnectResponse
    end

    def supports?(source)
      source.is_a? payment_source_class
    end

    def authorize(_money_in_cents, source, _gateway_options)
      Rails.logger.info "Received call to authorize, examining source..."

      ActiveMerchant::Billing::Response.new(
        source.success?,
        source.status,
        {},
        error_code: source.approval_code,
        authorization: source.transaction_id,
      )
    end

    def capture(amount, transaction_id, _gateway_options)
      Rails.logger.info "Received call to capture, with amount: #{amount}, transaction_id: #{transaction_id}"
      api_client.capture(transaction_id, amount)
    end

    def refund(amount, transaction_id, _gateway_options)
      Rails.logger.info "Received call to refund, with amount: #{amount}, transaction_id: #{transaction_id}"
      api_client.refund(transaction_id, amount)
    end

    def void(amount, transaction_id, _gateway_options)
      Rails.logger.info "Received call to void, with amount: #{amount}, transaction_id: #{transaction_id}"
      api_client.void(transaction_id)
    end

    private

    def api_client
      ::Telecash::ApiClient.new(
        preferences[:wsdl],
        preferences[:namespace],
        preferences[:api_user],
        preferences[:api_password],
        preferences[:ssl_certificate],
        preferences[:ssl_certificate_key],
        preferences[:ssl_certificate_key_password],
      )
    end
  end
end
