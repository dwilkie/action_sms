# action_sms

action_sms is a lightweight wrapper based on [activesms](http://github.com/nofxx/activesms). action_sms allows you to use existing SMS Gateway Adapters and switch between them effortlessly without modifing your application code. Unlike [activesms](http://github.com/nofxx/activesms), action_sms does not implement any SMS Gateway Adapters. For this see [action_sms_gateways](http://github.com/dwilkie/action_sms_gateways)

## Usage
Establish a connection to your SMS Gateway Adapter:

    ActionSms::Base.establish_connection(
      :adapter => 'your_adapter',
      # the remaining options are specific to the SMS Gateway Adapter
      :username => '[username]',
      :password => '[password]'
    )
The only required option is `:adapter`. This specifies the SMS Gateway adapter you want to use. The remaining options are specific to the adapter.

Then subclass `ActionSms::Base` to define a notifier

    class SMSNotifier < ActionSms::Base
    end

Now you can call:

    SMSNotifier.deliver(sms)

### Rails
For convenience there are a couple of generators that can be used if you are using action_sms within a Rails app.

    rails g initializer
Generates an initializer under config/initializers with the `establish_connection` code described above.

    rails g notifier
Generates a notifier under app/notifiers with the `SMSNotifier` code described above.

## Installation

    gem install action_sms
### Rails
Place the following in your Gemfile:

    gem action_sms
## SMS Gateway Adapters
See [action_sms_gateways](http://github.com/dwilkie/action_sms_gateways)

Copyright (c) 2010 David Wilkie, released under the MIT license

