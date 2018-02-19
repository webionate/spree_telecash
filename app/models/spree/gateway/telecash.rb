module Spree
  class Gateway::Telecash < Gateway

    preference :url, :string, default: "https://test.ipg-online.com/connect/gateway/processing"
    preference :store, :string, default: ""
    preference :secret, :string, default: ""

    def method_type
      'telecash'
    end

    def payment_source_class
      Telecash::ConnectResponse
    end

    def provider_class
      ::Telecash::Provider
    end

    def authorize(money_in_cents, source, gateway_options)
      Rails.logger.info "Received call to authorize, examining source..."
      ActiveMerchant::Billing::Response.new(
        source.success?,
        source.status,
        {},
        {
          error_code: source.approval_code,
          authorization: source.transaction_id
        }
      )
    end

    def capture(amount, transaction_id, _gateway_options)
      Rails.logger.info "Received call to capture"
    end


  end
end
