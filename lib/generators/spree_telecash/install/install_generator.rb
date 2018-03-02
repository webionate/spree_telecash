module SpreeTelecash
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :auto_run_migrations, type: :boolean, default: false

      def add_javascripts
        append_file "vendor/assets/javascripts/spree/frontend/all.js", "//= require spree/frontend/spree_telecash\n"
        append_file "vendor/assets/javascripts/spree/backend/all.js", "//= require spree/backend/spree_telecash\n"
      end

      def add_migrations
        run "bundle exec rake railties:install:migrations FROM=spree_telecash"
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ["", "y", "Y"].include?(
          ask("Would you like to run the migrations now? [Y/n]"),
        )
        if run_migrations
          run "bundle exec rake db:migrate"
        else
          # rubocop:disable Rails/Output
          puts "Skipping rake db:migrate, don't forget to run it!"
          # rubocop:enable Rails/Output
        end
      end
    end
  end
end
