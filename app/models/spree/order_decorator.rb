Spree::Order.class_eval do
  def save_telecash_payment(payment_method, telecash_response)
    payments.create(payment_method: payment_method, source: telecash_response, amount: telecash_response.amount)
    Rails.logger.info("Unable to update state to complete due to: #{errors.inspect}") unless self.next
  end
end
