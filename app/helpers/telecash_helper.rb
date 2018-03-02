module TelecashHelper
  def telecash_payment_link(order, payment_method, telecash_payment_method)
    Rails.logger.info("Trying to parse URI: #{payment_method.preferences[:url]}")
    Rails.logger.info("Trying to parse URI from payment_method: #{payment_method.inspect}")
    uri = URI.parse(payment_method.preferences[:url])
    store_id = payment_method.preferences[:store]
    formatted_date = Time.current.strftime("%Y:%m:%d-%H:%M:%S")
    uri.query = URI.encode_www_form(
      txntype: "preauth",
      timezone: "Europe/Berlin",
      txndatetime: formatted_date,
      hash_algorithm: "SHA256",
      hash: build_hash(store_id, formatted_date, "13.00", "978", payment_method.preferences[:secret]),
      storename: store_id,
      mode: "payonly",
      chargetotal: "13.00",
      currency: "978",
      oid: order.number,
      paymentMethod: telecash_payment_method,
      responseSuccessURL: "https://requestb.in/17w0evk1",
      responseFailURL: "https://requestb.in/17w0evk1",
    )
    uri.to_s
  end

  def needs_telecash_payment?(order, payment_method)
    order.payments.where(payment_method: payment_method).count.zero?
  end

  def telecash_success_link(order)
    telecash_connect_response_url(
      oid: order.number,
      approval_code: "Y:000000:4515581812:PPX :9MN61332EU967431F",
      txndate_processed: "14.02.18 13:58:50",
      txntype: "sale",
      txndatetime: "2018:02:14-12:57:31",
      timezone: "Europe/Berlin",
      sname: "test buyer",
      saddr1: "ESpachstr. 1",
      szip: "79111",
      scity: "Freiburg",
      scountry: "DE",
      cccountry: "N/A",
      ccbrand: "N/A",
      hash_algorithm: "SHA256",
      response_hash: "5e4a5e340466aa4bb46599bfbbd4ba1b169e0d4a08492a052cabe1f353c2c070",
      endpointTransactionId: "9MN61332EU967431F",
      chargetotal: order.total.to_s.tr(".", ","),
      currency: "978",
      processor_response_code: "Completed",
      terminal_id: "54000015",
      tdate: "1518613130",
      installments_interest: "false",
      _method: "post",
      paymentMethod: "paypal",
      ipgTransactionId: "84515581812",
      status: "GENEHMIGT",
    )
  end

  def telecash_payment_methods(payment_method)
    payment_method.preferences[:payment_methods].split(" ").map(&:downcase)
  end

  private

  def build_hash(*params)
    data_string = params.map(&:to_s).join
    hex_data = data_string.unpack("H*").first
    Digest::SHA256.hexdigest(hex_data)
  end
end
