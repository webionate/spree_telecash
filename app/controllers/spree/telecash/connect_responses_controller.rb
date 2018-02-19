module Spree
  class Telecash::ConnectResponsesController < Spree::StoreController
    protect_from_forgery with: :null_session

    def create
      Rails.logger.info("Processing Telecash Connect Response. Got params:\n#{params.inspect}")
      telecash_response = ::Telecash::ConnectResponse.from_params(params)
      if telecash_response.success?
        order = Spree::Order.where(number: telecash_response.order_number).first
        if order.present?
          order.save_telecash_payment(telecash_payment_method, telecash_response)
        else
          Rails.logger.error("unable to find order with number: #{telecash_response.order_number}")
        end
      end

      redirect_to checkout_state_path(:complete)
    end

    private

    def telecash_payment_method
      Spree::PaymentMethod.where(type: Spree::Gateway::TelecashCreditcard.name).first
    end
  end
end
