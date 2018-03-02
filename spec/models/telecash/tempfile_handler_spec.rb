module Telecash
  describe TempfileHandler do
    describe "#create" do
      it "returns the created tempfile" do
        expect(described_class.new.create("something")).to be_a Tempfile
      end

      it "creates a file in the filesystem" do
        tempfile = described_class.new.create("something")

        expect(File.exist?(tempfile.path)).to be true
      end

      it "adds the created tempfile to the list of tempfiles" do
        handler = described_class.new
        create_tempfile = -> { handler.create("something") }

        expect(create_tempfile).to change{handler.tempfiles.size}.from(0).to(1)
      end

      it "has the expected content" do
        tempfile = described_class.new.create("something")

        expect(File.read(tempfile.path)).to eq "something"

      end
    end

    describe "#clear" do
      it "closes all registered tempfiles" do
        handler = described_class.new
        tempfile_path = handler.create("something").path

        expect(File.exist?(tempfile_path)).to be true

        handler.clear

        expect(File.exist?(tempfile_path)).to be false
      end

      it "clears the list of registered tempfiles" do
        handler = described_class.new
        tempfile_path = handler.create("something").path

        handler.clear

        expect(handler.tempfiles).to be_empty
      end
    end
  end
end
