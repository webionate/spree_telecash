Deface::Override.new(
  virtual_path: 'spree/admin/shared/sub_menu/_configuration',
  name: 'Add Telecash configuration to submenu',
  insert_bottom: "[data-hook='admin_configurations_sidebar_menu']",
  #text: "  =configurations_sidebar_menu_item(t('telecash.settings.telecash_settings'), edit_admin_telecash_settings_path)"
  text: "<%= configurations_sidebar_menu_item(t('telecash.settings.telecash_settings'), edit_admin_telecash_settings_path) %>"
)
