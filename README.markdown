# action_sms

action_sms allows you to switch between SMS Gateways effortlessly without modifying your application or test code. By keeping SMS Gateway configuration out of your code you can be more adaptable to change.

## Current SMS Gateway Adapters

* [SMSGlobal](http://www.smsglobal.com)
* [Tropo](http://www.tropo.com)

## Adapter Specific Configuration

* [SMSGlobal](http://github.com/dwilkie/action_sms/wiki/SMSGlobal)
* [Tropo](http://github.com/dwilkie/action_sms/wiki/Tropo)

## Usage

### Configuration

Establish a connection to your SMS Gateway Adapter:

    ActionSms::Base.establish_connection(
      :adapter => 'your_adapter',
      # the remaining options are specific to the SMS Gateway Adapter
      :username => 'username',
      :password => 'password'
    )
The only required option is `:adapter`. This specifies the SMS Gateway adapter you want to use. The remaining options are specific to the adapter.

### Send an SMS and check if it was successful

    class SMS
      def recipient
        "617198378843"
      end

      def body
        "Hello world"
      end

      def from
      end
    end

    response = ActionSms::Base.deliver(SMS.new)
    success = ActionSms::Base.delivery_request_successful?(response)

### Receive an SMS

    # Assume 'params' has the data posted back to your server

    # get sender
    sender = ActionSms::Base.sender(params)

    # get message text
    message_text = ActionSms::Base.message_text(params)

### Delivery receipts

    # Assume 'receipt' has the data posted back to your server as the delivery receipt

    # get status
    status = ActionSms::Base.status(receipt)

    # get message id
    message_id = ActionSms::Base.message_id(receipt)

### Authentication

    ActionSms::Base.establish_connection(
      :authentication_key => "my secret",
      :use_ssl => true
    )

If you set up an: `authentication_key` in the configuration, your key will be passed back to your listener url. Using an authentication key in conjunction with a secure connection `use_ssl => true` helps protect you against someone faking incoming messages to your server. You can authenticate an incoming message as follows:

    # Assume 'params' has the data posted back to your server

    # Removes the authentication key from 'params' and returns true or false
    ActionSms::Base.authenticate(params)

### Service url

    # gets the gateway's api url
    # ActionSms::Base.service_url

## Testing

When you set: `:environment => "test"` in your configuration, you get some additional test helpers.

    ActionSms::Base.establish_connection(
      :environment => "test"
    )

    # get sample configuration
    ActionSms::Base.sample_configuration

    # get sample incoming SMS params
    ActionSms::Base.sample_incoming_sms

    # get customized sample incoming SMS
    ActionSms::Base.sample_incoming_sms(
      :message => "hello",
      :to => "6128392323",
      :from => "61289339432",
      :date => Time.now,
      :authentic => false     # see configuration
    )

    # get sample delivery response
    ActionSms::Base.sample_delivery_response

    # get sample delivery response (failed)
    ActionSms::Base.sample_delivery_response(:failed => true)

    # get a sample delivery response with a message id
    ActionSms::Base.sample_delivery_response_with_message_id("12345")

    # get sample message id
    ActionSms::Base.sample_message_id

    # get sample delivery receipt
    ActionSms::Base.sample_delivery_receipt

    # get customized sample delivery receipt
    ActionSms::Base.sample_delivery_receipt(
      :message_id => "12345",
      :status => "delivered",
      :error => "some error",
      :date => Time.now
    )

## Creating your own adapter

To create your own adapter all you need to do is open up the ActionSms::Base class
and add a class method named: `my_adapter_connection` which takes a single hash argument of configuration details and returns an instance of your adapter class. For example, let's create an adapter for clickatell:

    # clickatell_adapter.rb
    require 'action_sms/connection_adapters/abstract_adapter'

    module ActionSms
      class Base
        def self.clickatell_connection(config)
          ConnectionAdapters::ClickatellAdapter.new(config)
        end
      end
    end

    module ConnectionAdapters
      class ClickatellAdapter < AbstractAdapter
        # define your adapter here ...
        def initialize(config)
        end
      end
    end

Take a look at the [source](http://github.com/dwilkie/action_sms/tree/master/lib/action_sms/connection_adapters/) for more details

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

