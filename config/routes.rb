Spree::Core::Engine.routes.append do
  # Admin
  namespace :admin do
    resource :telecash_settings, only: %i(update edit)
  end

  namespace :telecash do
    resource :connect_response, only: :create
  end
end
