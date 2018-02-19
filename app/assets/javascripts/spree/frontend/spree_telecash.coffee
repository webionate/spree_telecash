$ ->

  $("input[name=telecash_payment_method]").on "change", (e) ->
    console.log $(this).val
