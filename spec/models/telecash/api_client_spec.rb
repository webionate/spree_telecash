require "savon"
require "nori"

module Telecash
  describe ApiClient do
    describe "#capture" do
      context "with a success soap response" do
        it "returns a billing response" do
          mock_savon_success("postauth_success_response_body.yml")
          client = ApiClient.new("example.wsdl", "user", "password", "cert", "cert_key", "cert_key_pass")

          response = client.capture("transaction_id", 22.99)

          expect(response).to be_a ActiveMerchant::Billing::Response
        end

        it "has a success state" do
          mock_savon_success("postauth_success_response_body.yml")
          client = ApiClient.new("example.wsdl", "user", "password", "cert", "cert_key", "cert_key_pass")

          response = client.capture("transaction_id", 22.99)

          expect(response.success?).to be true
        end

        it "has the expected message" do
          mock_savon_success("postauth_success_response_body.yml")
          client = ApiClient.new("example.wsdl", "user", "password", "cert", "cert_key", "cert_key_pass")

          response = client.capture("transaction_id", 22.99)

          expect(response.message).to eq "Function performed error-free - Y:SM0833:4515721339:YYYM:3908339911 - 84515721339"
        end
      end

      context "with a soap error" do
        it "returns a billing response" do
          mock_savon_fault("postauth_error_response.xml")
          client = ApiClient.new("example.wsdl", "user", "password", "cert", "cert_key", "cert_key_pass")

          response = client.capture("transaction_id", 22.99)

          expect(response).to be_a ActiveMerchant::Billing::Response
        end

        it "returns an error state" do
          mock_savon_fault("postauth_error_response.xml")
          client = ApiClient.new("example.wsdl", "user", "password", "cert", "cert_key", "cert_key_pass")

          response = client.capture("transaction_id", 22.99)

          expect(response.success?).to be false

        end

        it "has the expected message" do
          mock_savon_fault("postauth_error_response.xml")
          client = ApiClient.new("example.wsdl", "user", "password", "cert", "cert_key", "cert_key_pass")

          response = client.capture("transaction_id", 22.99)

          expect(response.message).to eq "SGS-010501: PostAuth already performed - N:-10501:PostAuth already performed - 84515721317"

        end
      end
    end

    def mock_savon_success(fixture)
      response_body = YAML.load(File.read(file_fixture(fixture)))
      response = double("response", body: response_body)
      client = double("client")
      allow(client).to receive(:call).and_return(response)
      allow(::Savon).to receive(:client).and_return(client)
    end

    def mock_savon_fault(xml_fixture)
      fault_xml = File.read(file_fixture(xml_fixture))
      http_response = double("http_response")
      client = double("client")

      allow(client).to receive(:call).and_raise(Savon::SOAPFault.new(http_response, nori, fault_xml))
      allow(::Savon).to receive(:client).and_return(client)
    end

    def nori
      globals = Savon::GlobalOptions.new

      nori_options = {
        :delete_namespace_attributes => globals[:delete_namespace_attributes],
        :strip_namespaces            => globals[:strip_namespaces],
        :convert_tags_to             => globals[:convert_response_tags_to],
        :convert_attributes_to       => globals[:convert_attributes_to],
      }

      non_nil_nori_options = nori_options.reject { |_, value| value.nil? }
      Nori.new(non_nil_nori_options)
    end
  end
end
