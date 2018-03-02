Spree Telecash
===================

Extends Spree for supporting Telecash Creditcard Payments. An appropriate Merchant Account is required to use it.

See also https://www.telecash.de/


Installation
------------

Add spree_telecash to your Gemfile:
```ruby
gem 'spree_telecash', :git => 'git://github.com/webionate/spree_telecash.git'
```

For a specific version use the appropriate branch, for example
```ruby
gem 'spree_telecash', :git => 'git://github.com/webionate/spree_telecash.git', :branch => 'master'
```


Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_telecash:install
```

You may run the migrations provided by the Spree Telecash Gem.

The Spree Telecash Gem supports authorize, capture, void and refund. Authorization is done via the Telecash Connect Frontend Redirect magic. capture, void and refund are realized through the SOAP API. See

https://www.telecash.de/produkte-services/e-commerce/support-fuer-entwickler/ipg-schnittstellen-fuer-entwickler/ for more details.


Setup
-----

Navigate to Spree Backend/Configuration/Payment Methods and add a new payment gateway with Provider "Spree::PaymentMethod::Telecash".

* Zahlungsmethoden - Telecash supports a number of payment methods. Enter the shortcut for the creditcard types, you want to process with telecash. You find the shortcuts in the Telecash Connect Documentation.
* URL - the URL of the Telecash connect Gateway to be used (either test url or production system)
* WSDL URL - Location of the SOAP WSDL File. This also depends on whether you are connecting to the test or production system
* Shop - The Shop ID of your Telecash Shop.
* Shared Secret - The Telecash Connect API Secret
* API User - The SOAP API User
* API Passwort - THe SOAP API Password
* SSL Zertifikat - The Certificate to be used for the TLS Connection to the SOAP API, from the .pem file povided by Telecash
* SSL Zertifikat Schlüssel - The Certificate Key to be used for the TLS Connection to the SOAP API, from the .key file provided by Telecash
* SSL Zertifikat Schlüssel Passwort - The password for the ssl certificate key provided by Telecash

The defaults provided (URL and WSDL URL) should work to access the testing system.

The Gem is currently hardcoded to use EUR as only currency.
