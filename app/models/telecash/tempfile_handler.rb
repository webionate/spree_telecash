module Telecash
  class TempfileHandler
    attr_reader :tempfiles

    def initialize
      @tempfiles = []
    end

    def create(content)
      Tempfile.new.tap do |tempfile|
        tempfile.write(content)
        tempfile.flush
        tempfiles << tempfile
      end
    end

    def clear
      tempfiles.each do |tempfile|
        tempfile.close(true)
        tempfiles.delete(tempfile)
      end
    end
  end
end
