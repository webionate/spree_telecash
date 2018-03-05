#= require spree/frontend

SpreeTeleCash =
  checkedPaymentMethod: ->
    $('div[data-hook="checkout_payment_step"] input[type="radio"][name="order[payments_attributes][][payment_method_id]"]:checked')

  paymentMethodId: ->
    $("#telecash-payment-method-selection").data("payment-method-id")

  selected: ->
    parseInt(SpreeTeleCash.checkedPaymentMethod().val()) == SpreeTeleCash.paymentMethodId()

  toggleSaveAndContinueButton: ->
    if SpreeTeleCash.selected()
      $("form#checkout_form_payment input[type=submit]").hide()
      $("[data-hook='continue-with-telecash']").show()
    else
      $("form#checkout_form_payment input[type=submit]").show()
      $("[data-hook='continue-with-telecash']").hide()

  setPaymentMethodURL: (url) ->
    $("[data-hook='continue-with-telecash']").attr("href", url)

  selectedPaymentMethodURL: ->
    $("input[name='telecash_payment_method']").val()

  removeCouponInput: ->
    $("[data-hook='coupon_code']").hide()

  hidePaymentSelection: ->
    if $(':radio[name="order[payments_attributes][][payment_method_id]"]').length == 1
      $("#payment-method-fields").hide()

$ ->
  if $("#telecash-payment-method-selection").length
    SpreeTeleCash.hidePaymentSelection()
    SpreeTeleCash.removeCouponInput()
    SpreeTeleCash.toggleSaveAndContinueButton()
    SpreeTeleCash.setPaymentMethodURL(SpreeTeleCash.selectedPaymentMethodURL())

    $("input[name='order[payments_attributes][][payment_method_id]']").on "change", (e) ->
      SpreeTeleCash.toggleSaveAndContinueButton()

    $("input[name='telecash_payment_method']").on "change", (e) ->
      SpreeTeleCash.setPaymentMethodURL($(this).val())
