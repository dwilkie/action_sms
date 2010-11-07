require 'net/https'

module ActionSms
  module ConnectionAdapters
    # All the concrete gateway adapters follow the interface laid down in this
    # class. You can use this interface directly by borrowing the gateway
    # connection from the Base with Base.connection.
    class AbstractAdapter
      require 'uri'

      def initialize(config = {}) #:nodoc:
        @config = config
      end

      def authenticate(params)
        params["authentication_key"] == @config[:authentication_key] ?
          params.delete("authentication_key") : nil
      end

      def authentication_key=(value)
        @config[:authentication_key] = value
      end

      def authentication_key
        @config[:authentication_key]
      end

      def use_ssl
        @config[:use_ssl]
      end

      def use_ssl=(value)
        @config[:use_ssl] = value
      end

      protected
        # Helper method to send an HTTP POST request to +url+ with paramaters
        # specified by the +params+ hash.
        def send_http_request(url, data)
          uri = URI.parse(url)
          req = Net::HTTP::Post.new(uri.path)
          data.is_a?(Hash) ? req.set_form_data(data) : req.body = data

          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true if uri.scheme == 'https'
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          resp = http.start do
            http.request(req)
          end
          resp.body
        end

        def service_url(service_uri)
          service_uri = URI.parse(service_uri)
          service_uri.scheme = @config[:use_ssl] ? "https" : "http"
          service_uri.to_s
        end
    end
  end
end

