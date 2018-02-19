Deface::Override.new(
  virtual_path: "spree/checkout/_payment",
  insert_bottom: "[data-hook='buttons']",
  partial: "spree/checkout/payment/continue_with_telecash_button",
  name: "continue-with-telecash-button",
)
