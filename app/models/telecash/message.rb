module Telecash
  class Message
    attr_reader :namespace_prefix

    IDENTIFIER_BY_TRANSACTION_TYPE = {
      "postAuth" => "OrderId",
      "return" => "OrderId",
      "void" => "IpgTransactionId",
    }.freeze

    def initialize(namespace_prefix: "")
      @namespace_prefix = namespace_prefix
    end

    def build(transaction, transaction_id, amount = nil)
      Hash.new.tap do |hash|
        hash[prefixed("Transaction")] = build_transaction(transaction, transaction_id, amount)
      end
    end

    private

    def build_transaction(type, id, amount)
      Hash.new.tap do |hash|
        hash[prefixed("CreditCardTxType")] = { prefixed("Type") => type }
        if amount.present?
          hash[prefixed("Payment")] = { prefixed("ChargeTotal") => amount, prefixed("Currency") => 978 }
        end
        hash[prefixed("TransactionDetails")] = { prefixed(IDENTIFIER_BY_TRANSACTION_TYPE[type]) => id }
      end
    end

    def prefixed(element)
      [namespace_prefix, element].delete_if(&:blank?).join(":")
    end
  end
end
