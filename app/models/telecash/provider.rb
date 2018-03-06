module Telecash
  class Provider
    attr_reader :wsdl, :api_user, :api_password, :ssl_certificate, :ssl_certificate_key, :ssl_certificate_key_password

    def initialize(gateway_options)
      @wsdl = gateway_options[:wsdl]
      @api_user = gateway_options[:api_user]
      @api_password = gateway_options[:api_password]
      @ssl_certificate = gateway_options[:ssl_certificate]
      @ssl_certificate_key = gateway_options[:ssl_certificate_key]
      @ssl_certificate_key_password = gateway_options[:ssl_certificate_key_password]
    end

    def authorize(_money_in_cents, source, _gateway_options)
      Rails.logger.info "Received call to authorize, examining source..."
      process_source(source)
    end

    def purchase(money_in_cents, source, gateway_options)
      Rails.logger.info "Received call to purchase with money #{money_in_cents}, source: #{source.inspect}, gateway_options #{gateway_options}"
      response = process_source(source)
      return response unless response.success?

      capture(money_in_cents, source.order_number, gateway_options)
    end

    def capture(money_in_cents, order_id, _gateway_options)
      Rails.logger.info "Received call to capture, with money_in_cents: #{money_in_cents}, transaction_id: #{order_id}"
      api_client.capture(order_id, money_in_cents / 100.00)
    end

    def credit(money_in_cents, transaction_id, options)
      originator = options[:originator]
      Rails.logger.info "Received call to credit, with money_in_cents: #{money_in_cents}, transaction_id: #{transaction_id} and options: #{options}"
      api_client.refund(order_number_from(originator), money_in_cents / 100.00)
    end

    def void(amount, transaction_id, _gateway_options)
      Rails.logger.info "Received call to void, with amount: #{amount}, transaction_id: #{transaction_id}"
      api_client.void(transaction_id)
    end

    private

    def process_source(payment_source)
      ActiveMerchant::Billing::Response.new(
        payment_source.success?,
        payment_source.status,
        {},
        error_code: payment_source.approval_code,
        authorization: payment_source.transaction_id,
      )
    end

    def order_number_from(originator)
      return if originator.nil?
      if originator.is_a? Spree::Refund

        originator.payment.order.number
      end
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
