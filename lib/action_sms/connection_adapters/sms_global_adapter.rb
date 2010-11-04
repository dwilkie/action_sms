require 'action_sms/connection_adapters/abstract_adapter'

module ActionSms
  class Base
    def self.sms_global_connection(config) #:nodoc:
      if config[:environment].to_s == "test"
        test_helper = File.expand_path(File.dirname(__FILE__) + '/test_helpers/sms_global')
        if File.exists?("#{test_helper}.rb")
          require test_helper
          ConnectionAdapters::SMSGlobalAdapter.class_eval do
            include ActionSms::ConnectionAdapters::TestHelpers::SMSGlobal
          end
        end
      end
      ConnectionAdapters::SMSGlobalAdapter.new(config)
    end
  end

  module ConnectionAdapters
    # All the concrete gateway adapters follow the interface laid down in this
    # class. You can use this interface directly by borrowing the gateway
    # connection from the Base with Base.connection.
    class SMSGlobalAdapter < AbstractAdapter

      SERVICE_URL = "http://smsglobal.com.au/http-api.php"

      def deliver(sms, options = {})
        params = {
          :action   => 'sendsms',
          :user     => @config[:user],
          :password => @config[:password],
          :maxsplit => @config[:maxsplit] || "19",
          :from     => sms.respond_to?(:from) ? sms.from : "reply2email",
          :to       => sms.recipient,
          :text     => (sms.body || "")
        }
        params.merge!(
          :userfield => sms.userfield
        ) if sms.respond_to?(:userfield)
        send_http_request(service_url, params)
      end

      def delivery_request_successful?(gateway_response)
        gateway_response =~ /^OK/
      end

      def message_id(data)
        sms_global_message_id_prefix = "SMSGlobalMsgID:"
        if data.is_a?(Hash)
          message_id = data["msgid"]
          sms_global_message_id_prefix + message_id if message_id
        elsif data.is_a?(String)
          match = /#{sms_global_message_id_prefix}\s*(\d+)/.match(data)
          sms_global_message_id_prefix + $1 if $1
        end
      end

      def message_text(params)
        params["msg"]
      end

      def sender(params)
        params["from"]
      end

      def service_url
        super(SERVICE_URL)
      end

      def status(delivery_receipt)
        delivery_receipt["dlrstatus"]
      end
    end
  end
end

