Spree::Core::Engine.routes.append do
  # Admin
  namespace :admin do
    resource :telecash_settings, only: %i(update edit)
  end
end
