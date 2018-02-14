module Spree
  module Admin
    class TelecashSettingsController < BaseController
      def edit
        @config = Spree::TelecashConfiguration.new
      end

      def update
        save_settings(params[:preferences])
        redirect_to edit_admin_telecash_settings_path
      end

      private

      def save_settings(values)
        config = Spree::TelecashConfiguration.new
        values.each do |name, value|
          next unless config.has_preference? name
          config[name] = value
        end
      end
    end
  end
end
