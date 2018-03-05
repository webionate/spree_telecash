module Telecash
  class Provider
    attr_reader :wsdl, :api_user, :api_password, :ssl_certificate, :ssl_certificate_key, :ssl_certificate_key_password

    def initialize(gateway_options)
      @wsdl = gateway_options[:wsdl]
      @api_user = gateway_options[:api_user]
      @api_password = gateway_options[:api_password]
      @ssl_certificate = gateway_options[:ssl_certificate]
      @ssl_certificate_key = gateway_option[:ssl_certificate_key]
      @ssl_certificate_key_password = gateway_options[:ssl_certificate_key_password]
    end

    def authorize(_money_in_cents, source, _gateway_options)
      Rails.logger.info "Received call to authorize, examining source..."
      process_source(source)
    end

    def purchase(_money_in_cents, source, _gateway_options)
      Rails.logger.info "Received call to purchase, examining source..."
      process_source(source)
    end

    def capture(amount, transaction_id, _gateway_options)
      Rails.logger.info "Received call to capture, with amount: #{amount}, transaction_id: #{transaction_id}"
      api_client.capture(transaction_id, amount)
    end

    def credit(amount, transaction_id, _gateway_options)
      Rails.logger.info "Received call to refund, with amount: #{amount}, transaction_id: #{transaction_id}"
      api_client.refund(transaction_id, amount)
    end

    def void(amount, transaction_id, _gateway_options)
      Rails.logger.info "Received call to void, with amount: #{amount}, transaction_id: #{transaction_id}"
      api_client.void(transaction_id)
    end

    private

    def process_source(payment_source)
      ActiveMerchant::Billing::Response.new(
        source.success?,
        source.status,
        {},
        error_code: source.approval_code,
        authorization: source.transaction_id,
      )
    end

    def api_client
      ApiClient.new(
        wsdl,
        api_user,
        api_password,
        ssl_certificate,
        ssl_certificate_key,
        ssl_certificate_key_password
      )
    end
  end
end
