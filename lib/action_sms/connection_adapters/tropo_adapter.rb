require 'action_sms/connection_adapters/abstract_adapter'

module ActionSms
  class Base
    def self.tropo_connection(config) #:nodoc:
      if config[:environment].to_s == "test"
        test_helper = File.expand_path(File.dirname(__FILE__) + '/test_helpers/tropo')
        if File.exists?("#{test_helper}.rb")
          require test_helper
          ConnectionAdapters::TropoAdapter.class_eval do
            include ActionSms::ConnectionAdapters::TestHelpers::Tropo
          end
        end
      end
      ConnectionAdapters::TropoAdapter.new(config)
    end
  end

  module ConnectionAdapters
    # All the concrete gateway adapters follow the interface laid down in this
    # class.  You can use this interface directly by borrowing the gateway
    # connection from the Base with Base.connection.
    class TropoAdapter < AbstractAdapter
      require 'tropo_message'

      SERVICE_URL = "http://api.tropo.com/1.0/sessions"

      def deliver(sms, options = {})
        tropo_message = Tropo::Message.new
        tropo_message.to = sms.recipient
        tropo_message.text = sms.body || ""
        tropo_message.from = sms.from if sms.respond_to?(:from)
        tropo_message.token = @config[:outgoing_token]
        response = send_http_request(service_url, tropo_message.request_xml)
        options[:filter_response] ? filter_response(response) : response
      end

      def delivery_request_successful?(gateway_response)
        gateway_response =~ /\<success\>true\<\/success\>/
      end

      def message_id(data)
        # this method is supposed to return nil
      end

      def message_text(params)
        session(params)["initial_text"]
      end

      def sender(params)
        session(params)["from"]["id"]
      end

      def service_url
        super(SERVICE_URL)
      end

      def status(delivery_receipt)
        # this method is supposed to return nil
      end

      private
        def session(params)
          params["session"]
        end

        def filter_response(raw_response)
          raw_response.gsub(/\<token\>\w+\<\/token\>/, "")
        end
    end
  end
end

