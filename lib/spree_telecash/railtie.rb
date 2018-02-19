require 'rails/railtie'
module SpreeTelecash
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/spree_telecash.rake'
    end

    initializer "telecash_helper" do
      ActionView::Base.send :include, TelecashHelper
    end
  end
end
