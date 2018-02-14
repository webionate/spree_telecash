module Spree
  class Gateway::TelecashPaypal < Gateway
    def method_type
      'telecash_paypal'
    end
  end
end
