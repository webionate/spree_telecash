module Telecash
  describe Message do
    describe "#build" do
      it "returns a Hash" do
        expect(described_class.new.build("void", "123456789", 12.99)).to be_a Hash
      end

      context "return message" do
        it "has the expected structure" do
          expect(described_class.new.build("return", "123456789", 12.99)).to eq expect_return_message("return", "123456789", 12.99)
        end

        it "has the expected structure with namespace" do
          expect(described_class.new(namespace_prefix: "hurz" ).build("return", "123456789", 12.99)).to eq expect_namespaced_return_message("return", "123456789", 12.99, "hurz")
        end
      end

      context "capture message" do
        it "has the expected structure" do
          expect(described_class.new.build("return", "123456789", 12.99)).to eq expect_capture_message("return", "123456789", 12.99)
        end
      end

      context "void message" do
        it "has the expected structure" do
          expect(described_class.new.build("void", "123456789")).to eq expect_void_message("void", "123456789")
        end
      end
    end

    def expect_void_message(type, id)
      {
        "Transaction" => {
          "CreditCardTxType" => {
            "Type" => type,
          },
          "TransactionDetails" => {
            "IpgTransactionId" => id,
          },
        },
      }
    end

    def expect_capture_message(type, id, amount)
      {
        "Transaction" => {
          "CreditCardTxType" => {
            "Type" => type,
          },
          "Payment"=> {
            "ChargeTotal"=>amount,
            "Currency"=>978,
          },
          "TransactionDetails" => {
            "OrderId" => id,
          },
        },
      }
    end

    def expect_return_message(type, id, amount)
      {
        "Transaction" => {
          "CreditCardTxType" => {
            "Type" => type,
          },
          "Payment"=> {
            "ChargeTotal"=>amount,
            "Currency"=>978,
          },
          "TransactionDetails" => {
            "OrderId" => id,
          },
        },
      }
    end

    def expect_namespaced_return_message(type, id, amount, namespace)
      {
        "#{namespace}:Transaction" => {
          "#{namespace}:CreditCardTxType" => {
            "#{namespace}:Type" => type,
          },
          "#{namespace}:Payment"=> {
            "#{namespace}:ChargeTotal"=>amount,
            "#{namespace}:Currency"=>978,
          },
          "#{namespace}:TransactionDetails" => {
            "#{namespace}:OrderId" => id,
          },
        },
      }
    end
  end
end
