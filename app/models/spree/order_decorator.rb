Spree::Order.class_eval do
  def save_telecash_payment(payment_method, telecash_response)
    Rails.logger.info("Authorized a payment through telecash")
    payment = payments.create(payment_method: payment_method, source: telecash_response, amount: telecash_response.amount)

    Rails.logger.info("Order requires Payments: #{self.payment_required?}")
    Rails.logger.info("Orders valid Payments is empty? #{self.payments.valid.empty?}")

    unless self.next
      Rails.logger.info("Unable to update state to complete due to: #{self.errors.inspect}")
    end
  end
end
