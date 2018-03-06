module Telecash
  class ConnectResponse < ApplicationRecord
    def self.table_name_prefix
      "telecash_"
    end

    def self.from_params(response_params)
      create(map_params(response_params))
    end

    def actions
      %w(capture void)
    end

    def can_capture?(payment)
      payment.pending? || payment.checkout?
    end

    def can_void?(payment)
      !payment.void?
    end

    def success?
      approval_code.present? && approval_code.first == "Y"
    end

    def amount
      parse_german_decimal(total)
    end

    def self.map_params(response_params)
      {
        order_number: response_params["oid"],
        payment_method: response_params["paymentMethod"],
        total: response_params["chargetotal"],
        currency: response_params["currency"],
        processor_response_code: response_params["processor_response_code"],
        status: response_params["status"],
        creditcard_brand: response_params["ccbrand"],
        response_hash: response_params["response_hash"],
        approval_code: response_params["approval_code"],
        transaction_id: response_params["ipgTransactionId"],
      }
    end

    def parse_german_decimal(string)
      Float(string.tr(",", "."))
    end
  end
end
