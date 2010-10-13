# action_sms

action_sms allows you to use existing or custom SMS Gateway Adapters and switch between them effortlessly without modifying your application or test code. By keeping SMS Gateway configuration out of your code you can be more adaptable to change.

## Usage

Establish a connection to your SMS Gateway Adapter:

    ActionSms::Base.establish_connection(
      :adapter => 'your_adapter',
      # the remaining options are specific to the SMS Gateway Adapter
      :username => '[username]',
      :password => '[password]'
    )
The only required option is `:adapter`. This specifies the SMS Gateway adapter you want to use. The remaining options are specific to the adapter.

Now from your application or test code you can call methods on the adapter by calling:

    ActionSms::Base.connection

## Adapters

See [action_sms_gateways](http://github.com/dwilkie/action_sms_gateways) for existing adapters and information on how to create your own.

## Rails

For convenience there is a generator that can be used if you are using action_sms within a Rails app

    rails g action_sms:initializer

Generates an initializer under config/initializers with the `establish_connection` code described above.

## Installation

    gem install action_sms

### Rails

Place the following in your Gemfile:

    gem action_sms

Copyright (c) 2010 David Wilkie, released under the MIT license

