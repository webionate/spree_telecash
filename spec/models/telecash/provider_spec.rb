module Telecash
  describe Provider do
    it "reads the required params from the gateway options" do
      provider = described_class.new(gateway_options)

      expect(provider.wsdl).to eq "some wsdl"
      expect(provider.api_user).to eq "user"
      expect(provider.api_password).to eq "password"
      expect(provider.ssl_certificate).to eq "cert content"
      expect(provider.ssl_certificate_key).to eq "cert key content"
      expect(provider.ssl_certificate_key_password).to eq "key password"
    end

    it "provides the expected payment actions" do
      provider = described_class.new(gateway_options)
      expect(provider).to respond_to(:authorize)
      expect(provider).to respond_to(:purchase)
      expect(provider).to respond_to(:capture)
      expect(provider).to respond_to(:void)
      expect(provider).to respond_to(:credit)
    end

    describe "#authorize" do
      context "with success source" do
        it "returns a billing response for the source" do
          provider = described_class.new(gateway_options)

          response = provider.authorize(10000, success_source, {})

          expect(response).to be_a ActiveMerchant::Billing::Response
        end

        it "is successful" do
          provider = described_class.new(gateway_options)

          response = provider.authorize(10000, success_source, {})

          expect(response.success?).to be true
        end
      end

      context "with fail source" do
        it "returns a billing response for the source" do
          provider = described_class.new(gateway_options)

          response = provider.authorize(10000, fail_source, {})

          expect(response).to be_a ActiveMerchant::Billing::Response
        end

        it "is not successful" do
          provider = described_class.new(gateway_options)

          response = provider.authorize(10000, fail_source, {})

          expect(response.success?).to be false
        end
      end
    end

    describe "#purchase" do
      context "with success source" do
        it "captures via the source" do
          billing_response = double("billing_response")
          mock_api_client(:capture, billing_response)

          provider = described_class.new(gateway_options)
          response = provider.purchase(10000, success_source, {})

          expect(response).to eq billing_response
        end
      end

      context "with fail source" do
        it "returns a billing response for the source" do
          provider = described_class.new(gateway_options)

          response = provider.purchase(10000, fail_source, {})

          expect(response).to be_a ActiveMerchant::Billing::Response
        end

        it "is not successful" do
          provider = described_class.new(gateway_options)

          response = provider.purchase(10000, fail_source, {})

          expect(response.success?).to be false
        end
      end
    end

    describe "#capture" do
      it "returns the billing response created by api_client" do
        provider = described_class.new(gateway_options)

        billing_response = double("billing_response")
        mock_api_client(:capture, billing_response)

        response = provider.capture(10000, "hurz", {})

        expect(response).to eq billing_response
      end
    end

    describe "#credit" do
      it "returns the billing response created by api_client" do
        provider = described_class.new(gateway_options)

        billing_response = double("billing_response")
        mock_api_client(:refund, billing_response)

        response = provider.credit(10000, "hurz", {})

        expect(response).to eq billing_response
      end
    end

    describe "#void" do
      it "returns the billing response created by api_client" do
        provider = described_class.new(gateway_options)

        billing_response = double("billing_response")
        mock_api_client(:void, billing_response)

        response = provider.void(10000, "hurz", {})

        expect(response).to eq billing_response
      end
    end

    def mock_api_client(action, response)
      api_client_mock = double("api_client")
      allow(api_client_mock).to receive(action.to_sym).and_return(response)
      allow(ApiClient).to receive(:new).and_return(api_client_mock)
    end


    def gateway_options
      {
        wsdl: "some wsdl",
        api_user: "user",
        api_password: "password",
        ssl_certificate: "cert content",
        ssl_certificate_key: "cert key content",
        ssl_certificate_key_password: "key password",
      }
    end

    def success_source
      Telecash::ConnectResponse.new(
        approval_code: "Y:000000:4515657775:PPX :0NV86527DH2644039",
        status: "GENEHMIGT",
        transaction_id: "84515657775",
      )
    end

    def fail_source
      Telecash::ConnectResponse.new(
        approval_code: "N:10423:This transaction cannot be completed with PaymentAction of Authorization.",
        status: "ABGELEHNT",
        transaction_id: "84515582470",
      )
    end
  end
end
