module Telecash
  class ApiClient

    NAMESPACE_PREFIX = "v1"

    NAMESPACES = { "xmlns:#{NAMESPACE_PREFIX}" => "http://ipg-online.com/ipgapi/schemas/v1" }

    attr_reader :wsdl, :user, :password, :certificate, :key, :key_password
    def initialize(wsdl, user, password, certificate, key, key_password)
      @wsdl = wsdl
      @user = user
      @password = password
      @certificate = certificate
      @key = key
      @key_password = key_password
    end

    def capture(transaction_id, amount)
      execute_soap_call(
        :ipg_api_order,
        Message.new(namespace_prefix: NAMESPACE_PREFIX).build("postAuth", transaction_id, amount),
      )
    end

    def refund(transaction_id, amount)
      execute_soap_call(
        :ipg_api_order,
        Message.new(namespace_prefix: NAMESPACE_PREFIX).build("return", transaction_id, amount),
      )
    end

    def void(transaction_id)
      execute_soap_call(
        :ipg_api_order,
        Message.new(namespace_prefix: NAMESPACE_PREFIX).build("void", transaction_id),
      )
    end

    private

    def execute_soap_call(operation, message)
      response = savon_client.call(operation, message: message)
      process_savon_response(response.body)
    rescue Savon::SOAPFault => e
      process_savon_response(e.to_hash.dig(:fault, :detail))
    ensure
      tempfile_handler.clear
    end

    def process_savon_response(hash)
      Rails.logger.info("Processing response body: #{hash}")
      ActiveMerchant::Billing::Response.new(success?(hash), build_response_message(hash))
    end

    def success?(hash)
      hash.dig(:ipg_api_order_response, :approval_code).to_s.first == "Y"
    end

    def build_response_message(hash)
      message = hash.dig(:ipg_api_order_response, :processor_response_message)
      error_message = hash.dig(:ipg_api_order_response, :error_message)
      approval_code = hash.dig(:ipg_api_order_response, :approval_code)
      transaction_id = hash.dig(:ipg_api_order_response, :ipg_transaction_id)
      [message, error_message, approval_code, transaction_id].delete_if(&:blank?).join(" - ")
    end

    def savon_client
      ::Savon.client(
        log: true,
        logger: Rails.logger,
        wsdl: wsdl,
        namespaces: NAMESPACES,
        basic_auth: [user, password],
        ssl_cert_file: tempfile_handler.create(certificate),
        ssl_cert_key_file: tempfile_handler.create(key),
        ssl_cert_key_password: key_password,
      )
    end

    def tempfile_handler
      @tempfile_handler ||= TempfileHandler.new
    end
  end
end
