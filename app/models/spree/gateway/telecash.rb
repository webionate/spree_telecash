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

    def provider_class
      ::Telecash::Provider
    end

    def supports?(source)
      source.is_a? payment_source_class
    end
  end
end
