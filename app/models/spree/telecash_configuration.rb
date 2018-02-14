module Spree
  class TelecashConfiguration < Spree::Preferences::Configuration
    preference :url, :string, default: "api.shipcloud.io"
    preference :store, :string, default: ""
    preference :secret, :string, default: ""
  end
end
